
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapappliation/marker_data.dart';
import 'package:http/http.dart' as http;
import 'package:mapappliation/hum.dart';




class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<MarkerData> _markerData = [];
  List<Marker> _markers = []; 
  LatLng? _selectedPosition;
  LatLng? _mylocation;
  LatLng? _draggedPosition;
  bool _isDragging = false;
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  
  
  Future<Position> _determinePosition() async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();


    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are permanently denied");
    }
    return await Geolocator.getCurrentPosition();

  }

  void _showCurrentLocation() async{
    try{
      Position position = await _determinePosition();
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      _mapController.move(currentLatLng, 15.0);
      setState(() {
        
        _mylocation = currentLatLng;
      });
    }catch(e){
      print(e);
    }
  }

  void _addMarker(LatLng position, String title, String description){
    setState(() {
      final markerData = MarkerData(position: position,title:title,description :
      description);
      _markerData.add(markerData);
      _markers.add(
        Marker(
          point: position,
          width: 80,
          height: 80,
        child: GestureDetector(
          onTap: () => _showMarkerInfo(markerData),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                constraints: BoxConstraints(maxWidth: 80), // Limit width to avoid overflow
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis, // Truncate if text is too long
                ),
              ),
              Icon(
                Icons.location_on,
                color: Colors.redAccent,
                size: 40,
              ),
            ],
          ),
        ),

        ),
        
      );
    });
  }

  void _showMarkerDialog(BuildContext context, LatLng position){
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
       builder: (context) => AlertDialog(
        title: Text('Add Marker'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions:[
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              _addMarker(position, titleController.text, descController.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
       )
       );
  }
// hum.dart

void handleMarkerClick(String title, String description) {
  // For example, you could print the title and description to the console
  print("Marker clicked! Title: $title, Description: $description");

  // You can add additional logic here, like navigating to a new screen or updating the UI
}

void _showMarkerInfo(MarkerData markerData) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(markerData.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              markerData.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    '60%', // You can replace this with your humidity value
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 10),
              onPressed: () {
                // When More About is clicked, navigate to CptPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CptPage(),
                  ),
                );
              },
              child: const Text("More About"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

  Future<void> _searchPlaces(String query) async {
  if (query.isEmpty) {
    setState(() {
      _searchResults = [];
    });
    return;
  }

  try {
    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data.isNotEmpty) {
        setState(() {
          _searchResults = data;
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error during search: $e');
    setState(() {
      _searchResults = [];
    });
  }
}


  void _moveToLocation(double Lat, double Long){
    LatLng location = LatLng(Lat, Long);
    _mapController.move(location, 15.0);
    setState(() {
      _selectedPosition = location;
      _searchResults = [];
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener((){
      _searchPlaces(_searchController.text);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(36.8065, 10.1815), // Coordinates for Tunis, Tunisia
              initialZoom: 13.0,
              onTap: (tapPosition, LatLng) {
                _selectedPosition = LatLng;
                _draggedPosition = _selectedPosition;

              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(markers: _markers),
              if(_isDragging && _draggedPosition != null)
              MarkerLayer(markers: [
                Marker(
                  width: 80,
                  height: 80,
                  point: _draggedPosition!,
                  child: Icon(Icons.location_on,
                  color: Colors.indigo,
                  size: 40,
                  )
                )
              ],
              ),
              if(_mylocation != null)
              MarkerLayer(markers: [
                Marker(
                  width: 80,
                  height: 80,
                  point: _mylocation!,
                  child: Icon(Icons.location_on,
                  color: Colors.green,
                  size: 40,
                  )
                )
              ]
              ),
              // Adding PolygonLayer to highlight a zone
           
            ],
          ),
        Positioned(
          top: 40,
          left: 15,
          right: 15,
          child: Column(
            children: [
              SizedBox(
                height: 55,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Place ..",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide : BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _isSearching ? IconButton(onPressed: (){
                      _searchController.clear();
                      setState(() {
                        _isSearching = false;
                        _searchResults = [];
                      });
                    }, icon: Icon(Icons.clear)):null
                  ),
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
              ),
              if(_isSearching && _searchResults.isNotEmpty)
              Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (ctx, index){
                    final place = _searchResults[index];
                    return ListTile(
                      title: Text(place['display_name'],),
                      onTap: (){
                        double? lat = double.parse(place['lat']);
                        double? lon = double.parse(place['lon']);
                        _moveToLocation(lat,lon);
                      },
                    );
                  },
                  ),
              )
            ],
          ),
        ),
        //add location button
        _isDragging == false ? Positioned(
          bottom: 20,
          left: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            onPressed: (){
              setState(() {
                _isDragging = true;
              });
            },
            child: Icon(Icons.add_location),
          ),
        ) : Positioned(
          bottom: 20,
          left: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            onPressed: (){
              setState(() {
                _isDragging = false;
              });
            },
            child: Icon(Icons.wrong_location),
          ),
        ), 
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            children: [
              FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.indigo,
                onPressed: _showCurrentLocation,
                child: Icon(Icons.location_searching_rounded),
          ), 
          if(_isDragging)
          Padding(padding: EdgeInsets.only(top: 20),
           child: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: (){
              if(_draggedPosition != null){
                _showMarkerDialog(context, _draggedPosition!);
              }
              setState(() {
                _isDragging = false;
                _draggedPosition = null;
              });
            },
            child: Icon(Icons.check),
            ), 
          )
            ],
          )
        ), 
        ],
      ),
    );
  }
}

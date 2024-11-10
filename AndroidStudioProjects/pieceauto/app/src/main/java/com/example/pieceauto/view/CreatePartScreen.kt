package com.example.pieceauto.view

import android.content.Context
import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.pieceauto.model.Part
import com.example.pieceauto.viewmodel.PartViewModel
import androidx.compose.material3.Checkbox
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import coil.compose.rememberImagePainter
import com.google.firebase.crashlytics.buildtools.reloc.org.apache.commons.codec.binary.Base64

@Composable
fun CreatePartScreen(partViewModel: PartViewModel = viewModel(), context: Context) {
    var name by remember { mutableStateOf("") }
    var brand by remember { mutableStateOf("") }
    var price by remember { mutableStateOf("") }
    var inStock by remember { mutableStateOf(false) }
    var used by remember { mutableStateOf(false) } // New "Used" checkbox
    var description by remember { mutableStateOf("") }
    var imageUri by remember { mutableStateOf<Uri?>(null) }
    var base64Image by remember { mutableStateOf<String?>(null) }

    // Launcher for image selection from gallery
    val galleryLauncher = rememberLauncherForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        imageUri = uri
        base64Image = uri?.let { uriToBase64(it, context) }
    }

    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        OutlinedTextField(value = name, onValueChange = { name = it }, label = { Text("Name") })
        OutlinedTextField(value = brand, onValueChange = { brand = it }, label = { Text("Brand") })
        OutlinedTextField(value = price, onValueChange = { price = it }, label = { Text("Price") })
        OutlinedTextField(value = description, onValueChange = { description = it }, label = { Text("Description") })

        // Checkbox for "In Stock"
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text("In Stock")
            Checkbox(checked = inStock, onCheckedChange = { inStock = it })
        }

        // Checkbox for "Used" status
        Row(verticalAlignment = Alignment.CenterVertically) {
            Text("Used")
            Checkbox(checked = used, onCheckedChange = { used = it })
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(onClick = { galleryLauncher.launch("image/*") }) {
            Text("Upload Image")
        }

        imageUri?.let {
            Spacer(modifier = Modifier.height(8.dp))
            Image(painter = rememberImagePainter(it), contentDescription = null, modifier = Modifier.size(100.dp))
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(onClick = {
            if (price.isNotBlank()) {
                val priceInt = price.toIntOrNull()
                if (priceInt != null) {
                    val part = Part(
                        name = name,
                        brand = brand,
                        price = priceInt,
                        inStock = inStock,
                        used = used, // Pass "Used" status to Part object
                        description = description,
                        image = base64Image // Set the Base64 image here
                    )
                    partViewModel.createPart(part)
                } else {
                    println("Invalid price")
                }
            } else {
                println("Price cannot be empty")
            }
        }) {
            Text("Publish Part")
        }
    }
}
private fun uriToBase64(uri: Uri, context: Context): String? {
    return try {
        context.contentResolver.openInputStream(uri)?.use { inputStream ->
            val bytes = inputStream.readBytes()
            java.util.Base64.getEncoder().encodeToString(bytes) // Use java.util.Base64 encoding
        }
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}
package com.example.pieceauto.view

import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.pieceauto.R
import com.example.pieceauto.model.Part
import com.example.pieceauto.viewmodel.PartViewModel

@Composable
fun PartsListScreen(partViewModel: PartViewModel = viewModel()) {
    var selectedPart by remember { mutableStateOf<Part?>(null) }

    // Fetch parts when the screen is first displayed
    LaunchedEffect(Unit) {
        partViewModel.fetchParts()
    }

    if (selectedPart != null) {
        // Show details screen if a part is selected
        PartDetailsScreen(
            part = selectedPart!!,
            onBackClick = { selectedPart = null } // Reset selected part on back
        )
    } else {
        // Show list of parts when no part is selected
        Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
            Text("Available Parts", style = MaterialTheme.typography.headlineLarge)

            // Display error message if any
            if (partViewModel.errorMessage.value.isNotEmpty()) {
                Text(partViewModel.errorMessage.value, color = Color.Red)
            }

            // Display the list of parts in a two-column grid
            LazyColumn {
                items(partViewModel.partList.chunked(2)) { rowParts ->
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        rowParts.forEach { part ->
                            PartItem(
                                part = part,
                                modifier = Modifier.weight(1f), // Distribute space evenly between items
                                onClick = {
                                    selectedPart = part // Set the selected part
                                }
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun PartItem(part: Part, modifier: Modifier = Modifier, onClick: () -> Unit) {
    Card(
        modifier = modifier
            .padding(8.dp)
            .clickable(onClick = onClick),
        elevation = CardDefaults.cardElevation(4.dp)
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.fillMaxWidth().padding(8.dp)
        ) {
            Image(
                painter = painterResource(id = R.drawable.placeholder), // Use part image here if available
                contentDescription = null,
                modifier = Modifier
                    .size(80.dp)
                    .clip(RectangleShape)
            )

            Text(
                text = "Name: ${part.name}",
                style = MaterialTheme.typography.bodyLarge,
                modifier = Modifier.padding(bottom = 4.dp)
            )
            Text(
                text = "Price: ${part.price}",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.primary
            )
            Text(
                text = "Brand: ${part.brand}",
                style = MaterialTheme.typography.bodyMedium
            )
            Text(
                text = "Description: ${part.description}",
                style = MaterialTheme.typography.bodyMedium
            )
        }
    }
}


package com.example.pieceauto.viewmodel

import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.pieceauto.model.Part
import com.example.pieceauto.model.ResponsePart
import com.example.pieceauto.network.PartApi
import kotlinx.coroutines.launch
import retrofit2.HttpException
import java.io.IOException

class PartViewModel : ViewModel() {
    // Mutable state list to store parts
    var partList = mutableStateListOf<Part>()
    var errorMessage = mutableStateOf("")

    fun createPart(part: Part) {
        viewModelScope.launch {
            try {
                PartApi.retrofitService.createPart(part)
                fetchParts() // Refresh the list after creation
            } catch (e: IOException) {
                errorMessage.value = "Network error"
            } catch (e: HttpException) {
                errorMessage.value = "Server error"
            }
        }
    }

    // Method to fetch all parts
    fun fetchParts() {
        viewModelScope.launch {
            try {
                val parts = PartApi.retrofitService.getAllParts()
                partList.clear() // Clear existing parts
                partList.addAll(parts) // Add fetched parts
            } catch (e: IOException) {
                errorMessage.value = "Network error"
            } catch (e: HttpException) {
                errorMessage.value = "Server error"
            }
        }
    }
}

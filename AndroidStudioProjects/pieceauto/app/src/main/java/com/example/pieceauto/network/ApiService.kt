package com.example.pieceauto.network

import com.example.pieceauto.model.Part
import com.example.pieceauto.model.ResponsePart
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST

interface ApiService {
    @POST("parts")
    suspend fun createPart(@Body part: Part): ResponsePart

    @GET("parts")
    suspend fun getAllParts(): List<Part>
}

private var BASE_URL = "http://192.168.1.17:3000/api/" // Adjust to your backend URL
private val retrofit: Retrofit = Retrofit.Builder()
    .addConverterFactory(GsonConverterFactory.create()) // For JSON parsing
    .baseUrl(BASE_URL)
    .build()

object PartApi {
    val retrofitService: ApiService by lazy {
        retrofit.create(ApiService::class.java)
    }
}

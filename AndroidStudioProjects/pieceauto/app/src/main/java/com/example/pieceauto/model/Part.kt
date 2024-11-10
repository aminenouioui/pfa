package com.example.pieceauto.model

import com.google.gson.annotations.SerializedName

data class Part(
	@SerializedName("price")
	val price: Int,

	@SerializedName("name")
	val name: String,

	@SerializedName("description")
	val description: String,

	@SerializedName("inStock")
	val inStock: Boolean,

	@SerializedName("brand")
	val brand: String,

	@SerializedName("used")
	val used: Boolean,

	@SerializedName("image")
	val image: String? = null,

	@SerializedName("_id")
	val id: String? = null,

	@SerializedName("__v")
	val v: Int? = null
)

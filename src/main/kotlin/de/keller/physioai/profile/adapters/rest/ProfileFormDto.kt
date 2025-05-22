package de.keller.physioai.profile.adapters.rest

import jakarta.validation.constraints.NotBlank

data class ProfileFormDto(
    @NotBlank
    val praxisName: String,
    @NotBlank
    val inhaberName: String,
    val profilePictureUrl: String?,
)

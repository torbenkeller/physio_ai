package de.keller.physioai.profile.adapters.api

import jakarta.validation.constraints.NotBlank

data class ProfileFormDto(
    @NotBlank
    val praxisName: String,
    @NotBlank
    val inhaberName: String,
    val profilePictureUrl: String?,
    val defaultBehandlungenProRezept: Int = 8,
    val externalCalendarUrl: String? = null,
)

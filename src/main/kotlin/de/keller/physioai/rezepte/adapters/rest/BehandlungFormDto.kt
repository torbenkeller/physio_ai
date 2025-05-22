package de.keller.physioai.rezepte.adapters.rest

import java.time.LocalDateTime

data class BehandlungFormDto(
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
)

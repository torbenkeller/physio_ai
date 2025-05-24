package de.keller.physioai.behandlung.adapters.api

import java.time.LocalDateTime
import java.util.UUID

data class BehandlungFormDto(
    val patientId: UUID,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val rezeptId: UUID?,
)

package de.keller.physioai.behandlungen.adapters.api

import java.time.LocalDateTime
import java.util.UUID

data class BehandlungFormDto(
    val patientId: UUID,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val rezeptId: UUID?,
    val behandlungsartId: UUID?,
)

package de.keller.physioai.behandlungen.adapters.api

import java.time.LocalDateTime
import java.util.UUID

data class TimeSlotCheckDto(
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
)

data class ConflictCheckRequestDto(
    val slots: List<TimeSlotCheckDto>,
)

data class ConflictResultDto(
    val slotIndex: Int,
    val hasConflict: Boolean,
    val conflictingBehandlungen: List<ConflictingBehandlungDto>,
)

data class ConflictingBehandlungDto(
    val id: UUID,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val patientName: String,
)

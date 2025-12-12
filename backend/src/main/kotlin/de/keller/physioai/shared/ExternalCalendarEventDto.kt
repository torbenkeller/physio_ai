package de.keller.physioai.shared

import java.time.LocalDateTime

data class ExternalCalendarEventDto(
    val id: String,
    val title: String,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val isAllDay: Boolean,
)

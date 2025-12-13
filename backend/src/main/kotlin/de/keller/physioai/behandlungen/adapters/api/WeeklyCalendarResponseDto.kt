package de.keller.physioai.behandlungen.adapters.api

import java.time.LocalDate
import java.time.LocalDateTime

data class WeeklyCalendarResponseDto(
    val behandlungen: Map<LocalDate, List<BehandlungKalenderDto>>,
    val externeTermine: List<ExternalCalendarEventDto>,
)

data class ExternalCalendarEventDto(
    val id: String,
    val title: String,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val isAllDay: Boolean,
)

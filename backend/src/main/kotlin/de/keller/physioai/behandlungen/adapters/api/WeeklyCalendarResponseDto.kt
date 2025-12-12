package de.keller.physioai.behandlungen.adapters.api

import de.keller.physioai.shared.ExternalCalendarEventDto
import java.time.LocalDate

data class WeeklyCalendarResponseDto(
    val behandlungen: Map<LocalDate, List<BehandlungKalenderDto>>,
    val externeTermine: List<ExternalCalendarEventDto>,
)

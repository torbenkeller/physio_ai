package de.keller.physioai.profile.ports

import de.keller.physioai.shared.ProfileId
import org.jmolecules.architecture.hexagonal.PrimaryPort
import java.time.LocalDate
import java.time.LocalDateTime

@PrimaryPort
interface ExternalCalendarService {
    fun getExternalEvents(
        profileId: ProfileId,
        startDate: LocalDate,
        endDate: LocalDate,
    ): List<ExternalCalendarEvent>

    data class ExternalCalendarEvent(
        val uid: String,
        val title: String,
        val startZeit: LocalDateTime,
        val endZeit: LocalDateTime,
        val isAllDay: Boolean,
    )
}

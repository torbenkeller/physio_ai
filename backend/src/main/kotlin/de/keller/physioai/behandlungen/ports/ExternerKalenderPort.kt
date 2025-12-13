package de.keller.physioai.behandlungen.ports

import org.jmolecules.architecture.hexagonal.SecondaryPort
import java.time.LocalDate
import java.time.LocalDateTime

/**
 * Secondary port for fetching external calendar events.
 * The implementation (adapter) handles the technical details of
 * parsing iCal feeds, HTTP requests, caching, etc.
 */
@SecondaryPort
interface ExternerKalenderPort {
    /**
     * Fetches external calendar events for a specific date range.
     *
     * @param calendarUrl The URL of the iCal calendar feed
     * @param startDate Start of the date range (inclusive)
     * @param endDate End of the date range (inclusive)
     * @return List of external calendar events within the date range
     */
    fun getExterneTermine(
        calendarUrl: String,
        startDate: LocalDate,
        endDate: LocalDate,
    ): List<ExternerTermin>

    data class ExternerTermin(
        val uid: String,
        val title: String,
        val startZeit: LocalDateTime,
        val endZeit: LocalDateTime,
        val isAllDay: Boolean,
    )
}

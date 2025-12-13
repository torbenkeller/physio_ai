package de.keller.physioai.behandlungen.ports

import de.keller.physioai.behandlungen.domain.KalenderEinstellungen
import org.jmolecules.architecture.hexagonal.PrimaryPort
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID

/**
 * Primary port for unified calendar view functionality.
 * Combines internal treatments (Behandlungen) with external calendar events.
 */
@PrimaryPort
interface KalenderAnsichtService {
    /**
     * Gets the weekly calendar view combining treatments and external events.
     */
    fun getWochenkalender(datum: LocalDate): WochenkalenderResponse

    /**
     * Gets the current calendar settings.
     */
    fun getKalenderEinstellungen(): KalenderEinstellungen

    /**
     * Updates the external calendar URL.
     */
    fun updateExternalCalendarUrl(url: String?): KalenderEinstellungen

    data class WochenkalenderResponse(
        val behandlungen: Map<LocalDate, List<BehandlungTermin>>,
        val externeTermine: List<ExternerTerminResponse>,
    )

    data class BehandlungTermin(
        val id: UUID,
        val patientId: UUID,
        val patientVorname: String,
        val patientNachname: String,
        val patientGeburtstag: LocalDate?,
        val startZeit: LocalDateTime,
        val endZeit: LocalDateTime,
        val rezeptId: UUID?,
        val behandlungsartId: UUID?,
        val bemerkung: String?,
    )

    data class ExternerTerminResponse(
        val uid: String,
        val title: String,
        val startZeit: LocalDateTime,
        val endZeit: LocalDateTime,
        val isAllDay: Boolean,
    )
}

package de.keller.physioai.behandlungen

import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import java.time.LocalDateTime

/**
 * Domain Event das publiziert wird, wenn mehrere Behandlungen auf einmal erstellt werden.
 * Enthält alle Behandlungen gruppiert nach Patient, sodass die Patientenakte
 * alle Einträge in einer Transaktion verarbeiten kann.
 */
data class BehandlungenGeaendertEvent(
    val behandlungen: List<BehandlungData>,
) {
    data class BehandlungData(
        val behandlungId: BehandlungId,
        val patientId: PatientId,
        val startZeit: LocalDateTime,
        val bemerkung: String?,
    )
}

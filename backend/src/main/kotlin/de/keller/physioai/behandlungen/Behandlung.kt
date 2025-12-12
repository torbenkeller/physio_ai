package de.keller.physioai.behandlungen

import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.BehandlungsartId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import java.time.LocalDateTime

/**
 * Public interface for Behandlung (treatment) entity.
 * This is the public API of the behandlungen module for reading treatment data.
 */
interface Behandlung {
    val id: BehandlungId
    val patientId: PatientId
    val startZeit: LocalDateTime
    val endZeit: LocalDateTime
    val rezeptId: RezeptId?
    val behandlungsartId: BehandlungsartId?
    val bemerkung: String?
}

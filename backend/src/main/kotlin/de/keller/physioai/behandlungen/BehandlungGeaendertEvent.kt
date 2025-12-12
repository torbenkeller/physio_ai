package de.keller.physioai.behandlungen

import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import java.time.LocalDateTime

/**
 * Domain Event das publiziert wird, wenn eine Behandlung gespeichert wird.
 * Wird vom BehandlungAggregate via @DomainEvents publiziert.
 */
data class BehandlungGeaendertEvent(
    val behandlungId: BehandlungId,
    val patientId: PatientId,
    val startZeit: LocalDateTime,
    val bemerkung: String?,
)

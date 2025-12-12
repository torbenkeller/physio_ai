package de.keller.physioai.behandlungen

import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId

/**
 * Domain Event das publiziert wird, wenn eine Behandlung gelöscht wird.
 * Wird manuell im BehandlungenService publiziert, da @DomainEvents
 * nur bei save() funktioniert, nicht bei delete().
 */
data class BehandlungGeloeschtEvent(
    val behandlungId: BehandlungId,
    val patientId: PatientId,
)

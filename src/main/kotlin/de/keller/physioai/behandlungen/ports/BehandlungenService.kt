package de.keller.physioai.behandlungen.ports

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.jmolecules.architecture.hexagonal.PrimaryPort
import java.time.LocalDateTime

@PrimaryPort
interface BehandlungenService {
    fun createBehandlung(
        patientId: PatientId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
    ): BehandlungAggregate

    fun updateBehandlung(
        id: BehandlungId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
    ): BehandlungAggregate

    fun deleteBehandlung(id: BehandlungId)
}

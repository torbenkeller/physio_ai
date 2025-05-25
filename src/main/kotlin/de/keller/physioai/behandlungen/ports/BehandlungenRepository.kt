package de.keller.physioai.behandlungen.ports

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import org.jmolecules.architecture.hexagonal.SecondaryPort
import java.time.LocalDateTime

@SecondaryPort
interface BehandlungenRepository {
    fun save(behandlung: BehandlungAggregate): BehandlungAggregate

    fun findById(id: BehandlungId): BehandlungAggregate?

    fun findAllByPatientId(patientId: PatientId): List<BehandlungAggregate>

    fun findAll(): List<BehandlungAggregate>

    fun delete(behandlung: BehandlungAggregate)

    fun findAllByDateRange(
        startDateTime: LocalDateTime,
        endDateTime: LocalDateTime,
    ): List<BehandlungAggregate>
}

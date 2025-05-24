package de.keller.physioai.behandlung.ports

import de.keller.physioai.behandlung.domain.BehandlungAggregate
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import org.jmolecules.architecture.hexagonal.SecondaryPort

@SecondaryPort
interface BehandlungRepository {
    fun save(behandlung: BehandlungAggregate): BehandlungAggregate

    fun findById(id: BehandlungId): BehandlungAggregate?

    fun findAllByPatientId(patientId: PatientId): List<BehandlungAggregate>

    fun findAll(): List<BehandlungAggregate>

    fun delete(behandlung: BehandlungAggregate)
}

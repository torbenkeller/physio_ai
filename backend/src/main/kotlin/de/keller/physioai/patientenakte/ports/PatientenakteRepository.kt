package de.keller.physioai.patientenakte.ports

import de.keller.physioai.patientenakte.domain.PatientenakteAggregate
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.PatientenakteId
import org.jmolecules.architecture.hexagonal.SecondaryPort

@SecondaryPort
interface PatientenakteRepository {
    fun save(patientenakte: PatientenakteAggregate): PatientenakteAggregate

    fun findById(id: PatientenakteId): PatientenakteAggregate?

    fun findByPatientId(patientId: PatientId): PatientenakteAggregate?

    fun delete(patientenakte: PatientenakteAggregate)
}

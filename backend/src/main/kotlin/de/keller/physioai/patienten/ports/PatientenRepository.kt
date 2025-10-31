package de.keller.physioai.patienten.ports

import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.shared.PatientId
import org.jmolecules.architecture.hexagonal.SecondaryPort
import java.time.LocalDate

@SecondaryPort
interface PatientenRepository : de.keller.physioai.patienten.PatientenRepository {
    override fun findById(id: PatientId): PatientAggregate?

    override fun findPatientByGeburtstag(geburtstag: LocalDate): List<PatientAggregate>

    override fun findAllByIdIn(ids: Collection<PatientId>): List<PatientAggregate>

    fun findAll(): List<PatientAggregate>

    fun save(patient: PatientAggregate): PatientAggregate

    fun deleteById(id: PatientId)
}

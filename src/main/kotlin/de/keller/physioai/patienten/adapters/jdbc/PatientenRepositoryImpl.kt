package de.keller.physioai.patienten.adapters.jdbc

import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.patienten.ports.PatientenRepository
import de.keller.physioai.shared.PatientId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.stereotype.Repository
import java.time.LocalDate

/***
 * This indirection is needed because spring data can not use kotlin value classes within collections as arguments.
 */
@SecondaryAdapter
@Repository
class PatientenRepositoryImpl(
    val patientenDAO: PatientenDAO,
) : PatientenRepository {
    override fun findAll(): List<PatientAggregate> = patientenDAO.findAll()

    override fun findById(id: PatientId): PatientAggregate? = patientenDAO.findById(id.id)

    override fun findAllByIdIn(ids: Collection<PatientId>): List<PatientAggregate> = patientenDAO.findAllByIdIn(ids = ids.map { it.id })

    override fun findPatientByGeburtstag(geburtstag: LocalDate): List<PatientAggregate> = patientenDAO.findPatientByGeburtstag(geburtstag)

    override fun save(patient: PatientAggregate): PatientAggregate = patientenDAO.save(patient)

    override fun deleteById(id: PatientId) = patientenDAO.deleteById(id.id)
}

package de.keller.physioai.patienten.ports

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.domain.PatientAggregate
import java.time.LocalDate

interface PatientenRepository : de.keller.physioai.patienten.PatientenRepository {
    override fun findById(id: PatientId): PatientAggregate?

    override fun findPatientByGeburtstag(geburtstag: LocalDate): List<PatientAggregate>

    fun findAll(): List<PatientAggregate>

    fun findAllByIdIn(ids: Collection<PatientId>): List<PatientAggregate>

    fun save(patient: PatientAggregate): PatientAggregate

    fun deleteById(id: PatientId)
}

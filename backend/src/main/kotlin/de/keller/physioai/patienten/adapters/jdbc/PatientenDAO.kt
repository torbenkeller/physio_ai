package de.keller.physioai.patienten.adapters.jdbc

import de.keller.physioai.patienten.domain.PatientAggregate
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate
import java.util.UUID

@Transactional(readOnly = true)
@Component
interface PatientenDAO : org.springframework.data.repository.Repository<PatientAggregate, UUID> {
    fun findAll(): List<PatientAggregate>

    fun findById(id: UUID): PatientAggregate?

    fun findAllByIdIn(ids: Collection<UUID>): List<PatientAggregate>

    fun findPatientByGeburtstag(geburtstag: LocalDate): List<PatientAggregate>

    @Transactional(readOnly = false)
    @Modifying
    fun save(patient: PatientAggregate): PatientAggregate

    @Transactional(readOnly = false)
    @Modifying
    fun deleteById(id: UUID)
}

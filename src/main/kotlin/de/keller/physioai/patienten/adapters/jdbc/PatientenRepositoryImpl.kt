package de.keller.physioai.patienten.adapters.jdbc

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.patienten.ports.PatientenRepository
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate

@SecondaryAdapter
@Transactional(readOnly = true)
@Repository
interface PatientenRepositoryImpl :
    org.springframework.data.repository.Repository<PatientAggregate, PatientId>,
    PatientenRepository {
    override fun findAll(): List<PatientAggregate>

    override fun findById(id: PatientId): PatientAggregate?

    override fun findAllByIdIn(ids: Collection<PatientId>): List<PatientAggregate>

    override fun findPatientByGeburtstag(geburtstag: LocalDate): List<PatientAggregate>

    @Transactional(readOnly = false)
    @Modifying
    override fun save(patient: PatientAggregate): PatientAggregate

    @Transactional(readOnly = false)
    @Modifying
    override fun deleteById(id: PatientId)
}

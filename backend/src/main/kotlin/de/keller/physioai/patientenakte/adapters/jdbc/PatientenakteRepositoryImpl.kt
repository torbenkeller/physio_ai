package de.keller.physioai.patientenakte.adapters.jdbc

import de.keller.physioai.patientenakte.domain.PatientenakteAggregate
import de.keller.physioai.patientenakte.ports.PatientenakteRepository
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.PatientenakteId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.data.jdbc.repository.query.Query
import org.springframework.data.repository.Repository
import org.springframework.data.repository.query.Param
import org.springframework.transaction.annotation.Transactional

@SecondaryAdapter
@org.springframework.stereotype.Repository
@org.jmolecules.ddd.annotation.Repository
@Transactional(readOnly = true)
interface PatientenakteRepositoryImpl :
    PatientenakteRepository,
    Repository<PatientenakteAggregate, PatientenakteId> {
    @Transactional
    override fun save(patientenakte: PatientenakteAggregate): PatientenakteAggregate

    @Query("SELECT * FROM patientenakten WHERE id = :id")
    override fun findById(
        @Param("id") id: PatientenakteId,
    ): PatientenakteAggregate?

    @Query("SELECT * FROM patientenakten WHERE patient_id = :patientId")
    override fun findByPatientId(
        @Param("patientId") patientId: PatientId,
    ): PatientenakteAggregate?

    @Transactional
    override fun delete(patientenakte: PatientenakteAggregate)
}

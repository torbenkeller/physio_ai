package de.keller.physio_ai.patienten

import de.keller.physio_ai.config.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.data.convert.WritingConverter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate
import java.util.*
import org.springframework.data.repository.Repository as SpringDataJdbcRepository

@Transactional(readOnly = true)
@Repository
interface PatientenRepository : SpringDataJdbcRepository<Patient, PatientId> {
    fun findAll(): List<Patient>

    fun findById(id: PatientId): Patient?

    fun findAllById(ids: Iterable<PatientId>): List<Patient>

    fun findPatientByGeburtstag(geburtstag: LocalDate): List<Patient>

    @Transactional(readOnly = false)
    @Modifying
    fun save(patient: Patient): Patient?

    @Transactional(readOnly = false)
    @Modifying
    fun deleteById(id: PatientId)

}

@Component
@ReadingConverter
@SpringDataJdbcConverter
class PatientIdReadingConverter : Converter<UUID, PatientId> {
    override fun convert(source: UUID): PatientId = PatientId(source)
}

@Component
@WritingConverter
@SpringDataJdbcConverter
class PatientIdWritingConverter : Converter<PatientId, UUID> {
    override fun convert(source: PatientId): UUID = source.id
}

package de.keller.physioai.patienten

import de.keller.physioai.config.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.data.convert.WritingConverter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate
import java.util.UUID

@Transactional(readOnly = true)
@Repository
interface PatientenRepository : org.springframework.data.repository.Repository<Patient, PatientId> {
    fun findAll(): List<Patient>

    fun findById(id: PatientId): Patient?

    fun findAllByIdIn(ids: Collection<PatientId>): List<Patient>

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

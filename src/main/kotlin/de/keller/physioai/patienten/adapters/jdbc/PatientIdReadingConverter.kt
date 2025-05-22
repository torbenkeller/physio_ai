package de.keller.physioai.patienten.adapters.jdbc

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@ReadingConverter
@SpringDataJdbcConverter
class PatientIdReadingConverter : Converter<UUID, PatientId> {
    override fun convert(source: UUID): PatientId = PatientId.fromUUID(source)
}

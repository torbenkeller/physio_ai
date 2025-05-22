package de.keller.physioai.patienten.adapters.jdbc

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.WritingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@WritingConverter
@SpringDataJdbcConverter
class PatientIdWritingConverter : Converter<PatientId, UUID> {
    override fun convert(source: PatientId): UUID = source.id
}
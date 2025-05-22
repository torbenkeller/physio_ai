package de.keller.physioai.rezepte.adapters.jdbc.converters

import de.keller.physioai.rezepte.domain.ArztId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@ReadingConverter
@SpringDataJdbcConverter
class ArztIdReadingConverter : Converter<UUID, ArztId> {
    override fun convert(source: UUID): ArztId = ArztId.fromUUID(source)
}

package de.keller.physioai.rezepte.adapters.jdbc.converters

import de.keller.physioai.rezepte.domain.ArztId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.WritingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@WritingConverter
@SpringDataJdbcConverter
class ArztIdWritingConverter : Converter<ArztId, UUID> {
    override fun convert(source: ArztId): UUID = source.id
}

package de.keller.physioai.rezepte.adapters.jdbc.converters

import de.keller.physioai.rezepte.RezeptId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.WritingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@WritingConverter
@SpringDataJdbcConverter
class RezeptIdWritingConverter : Converter<RezeptId, UUID> {
    override fun convert(source: RezeptId): UUID = source.id
}

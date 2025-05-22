package de.keller.physioai.rezepte.adapters.jdbc.converters

import de.keller.physioai.rezepte.domain.BehandlungsartId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.WritingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@WritingConverter
@SpringDataJdbcConverter
class BehandlungsartIdWritingConverter : Converter<BehandlungsartId, UUID> {
    override fun convert(source: BehandlungsartId): UUID = source.id
}

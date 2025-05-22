package de.keller.physioai.rezepte.adapters.jdbc.converters

import de.keller.physioai.rezepte.domain.BehandlungsartId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@ReadingConverter
@SpringDataJdbcConverter
class BehandlungsartIdReadingConverter : Converter<UUID, BehandlungsartId> {
    override fun convert(source: UUID): BehandlungsartId = BehandlungsartId.fromUUID(source)
}

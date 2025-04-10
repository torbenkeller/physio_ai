package de.keller.physio_ai.rezepte

import de.keller.physio_ai.config.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.data.convert.WritingConverter
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository
import java.util.*


@Repository
interface AerzteRepository : CrudRepository<Arzt, ArztId> {
}

@Component
@ReadingConverter
@SpringDataJdbcConverter
class ArztIdReadingConverter : Converter<UUID, ArztId> {
    override fun convert(source: UUID): ArztId = ArztId(source)
}

@Component
@WritingConverter
@SpringDataJdbcConverter
class ArztIdWritingConverter : Converter<ArztId, UUID> {
    override fun convert(source: ArztId): UUID = source.id
}

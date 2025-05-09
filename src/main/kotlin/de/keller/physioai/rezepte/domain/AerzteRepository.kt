package de.keller.physioai.rezepte.domain

import de.keller.physioai.config.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.data.convert.WritingConverter
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface AerzteRepository : org.springframework.data.repository.Repository<Arzt, ArztId> {
    fun findById(id: ArztId): Arzt?

    fun findAllByIdIn(ids: Collection<ArztId>): List<Arzt>
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

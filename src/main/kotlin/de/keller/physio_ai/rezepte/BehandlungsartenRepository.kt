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
interface BehandlungsartenRepository : CrudRepository<Behandlungsart, BehandlungsartId> {
    fun findAllByName(names: Iterable<String>): List<Behandlungsart>

}

@Component
@ReadingConverter
@SpringDataJdbcConverter
class BehandlungsartIdReadingConverter : Converter<UUID, BehandlungsartId> {
    override fun convert(source: UUID): BehandlungsartId = BehandlungsartId(source)
}

@Component
@WritingConverter
@SpringDataJdbcConverter
class BehandlungsartIdWritingConverter : Converter<BehandlungsartId, UUID> {
    override fun convert(source: BehandlungsartId): UUID = source.id
}

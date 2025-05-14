package de.keller.physioai.rezepte.domain

import de.keller.physioai.config.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.data.convert.WritingConverter
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface BehandlungsartenRepository : CrudRepository<Behandlungsart, BehandlungsartId> {
    fun findAllByNameIn(names: Collection<String>): List<Behandlungsart>
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

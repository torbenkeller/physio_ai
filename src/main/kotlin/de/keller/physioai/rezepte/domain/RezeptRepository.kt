package de.keller.physioai.rezepte.domain

import de.keller.physioai.config.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.data.convert.WritingConverter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.stereotype.Component
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Transactional(readOnly = true)
@Repository
interface RezeptRepository : org.springframework.data.repository.Repository<Rezept, RezeptId> {
    fun findAll(): List<Rezept>

    fun findById(rezeptId: RezeptId): Rezept?

    @Transactional(readOnly = false)
    @Modifying
    fun deleteById(rezeptId: RezeptId)

    @Transactional(readOnly = false)
    @Modifying
    fun save(rezept: Rezept): Rezept
}

@Component
@ReadingConverter
@SpringDataJdbcConverter
class RezeptIdReadingConverter : Converter<UUID, RezeptId> {
    override fun convert(source: UUID): RezeptId = RezeptId(source)
}

@Component
@WritingConverter
@SpringDataJdbcConverter
class RezeptIdWritingConverter : Converter<RezeptId, UUID> {
    override fun convert(source: RezeptId): UUID = source.id
}

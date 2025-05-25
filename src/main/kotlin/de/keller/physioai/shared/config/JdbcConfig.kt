package de.keller.physioai.shared.config

import de.keller.physioai.shared.PatientId
import org.springframework.context.annotation.Configuration
import org.springframework.core.convert.converter.Converter
import org.springframework.data.jdbc.repository.config.AbstractJdbcConfiguration
import org.springframework.data.jdbc.repository.config.EnableJdbcAuditing
import java.util.UUID

@EnableJdbcAuditing
@Configuration
class JdbcConfig : AbstractJdbcConfiguration() {
    override fun userConverters(): List<*> = listOf(PatientIdCollectionConverter())
}

class PatientIdCollectionConverter : Converter<Collection<PatientId>, Collection<UUID>> {
    override fun convert(source: Collection<PatientId>): Collection<UUID> = source.map { it.id }
}

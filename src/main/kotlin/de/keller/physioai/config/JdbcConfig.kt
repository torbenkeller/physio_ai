package de.keller.physioai.config

import org.springframework.context.annotation.Configuration
import org.springframework.core.convert.converter.Converter
import org.springframework.data.jdbc.repository.config.AbstractJdbcConfiguration
import org.springframework.data.jdbc.repository.config.EnableJdbcAuditing

@EnableJdbcAuditing
@Configuration
class JdbcConfig(
    @SpringDataJdbcConverter val converters: List<Converter<*, *>>,
) : AbstractJdbcConfiguration() {
    override fun userConverters(): List<*> = converters
}

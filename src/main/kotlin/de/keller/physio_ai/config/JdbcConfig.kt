package de.keller.physio_ai.config

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
import com.fasterxml.jackson.datatype.jsr310.ser.InstantSerializer
import org.springframework.context.annotation.Configuration
import org.springframework.core.convert.converter.Converter
import org.springframework.data.jdbc.repository.config.AbstractJdbcConfiguration
import org.springframework.data.jdbc.repository.config.EnableJdbcAuditing
import java.time.Instant


@EnableJdbcAuditing
@Configuration
class JdbcConfig(
    val objectMapper: ObjectMapper,

    @SpringDataJdbcConverter val converters: List<Converter<*, *>>
) : AbstractJdbcConfiguration() {

    override fun userConverters(): List<*> {
        return converters
    }
}

package de.keller.physioai.shared.config

import org.springframework.context.annotation.Configuration
import org.springframework.data.jdbc.repository.config.AbstractJdbcConfiguration
import org.springframework.data.jdbc.repository.config.EnableJdbcAuditing

@EnableJdbcAuditing
@Configuration
class JdbcConfig : AbstractJdbcConfiguration()

package de.keller.physioai.profile.adapters.jdbc

import de.keller.physioai.shared.ProfileId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@ReadingConverter
@SpringDataJdbcConverter
class ProfileIdReadingConverter : Converter<UUID, ProfileId> {
    override fun convert(source: UUID): ProfileId = ProfileId.fromUUID(source)
}

package de.keller.physioai.profile.adapters.jdbc

import de.keller.physioai.shared.ProfileId
import de.keller.physioai.shared.SpringDataJdbcConverter
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.WritingConverter
import org.springframework.stereotype.Component
import java.util.UUID

@Component
@WritingConverter
@SpringDataJdbcConverter
class ProfileIdWritingConverter : Converter<ProfileId, UUID> {
    override fun convert(source: ProfileId): UUID = source.id
}

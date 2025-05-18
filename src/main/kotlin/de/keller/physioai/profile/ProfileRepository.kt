package de.keller.physioai.profile

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
interface ProfileRepository : org.springframework.data.repository.Repository<Profile, ProfileId> {
    fun findAll(): List<Profile>

    fun findById(id: ProfileId): Profile?

    @Transactional(readOnly = false)
    @Modifying
    fun save(profile: Profile): Profile?
}

@Component
@ReadingConverter
@SpringDataJdbcConverter
class ProfileIdReadingConverter : Converter<UUID, ProfileId> {
    override fun convert(source: UUID): ProfileId = ProfileId(source)
}

@Component
@WritingConverter
@SpringDataJdbcConverter
class ProfileIdWritingConverter : Converter<ProfileId, UUID> {
    override fun convert(source: ProfileId): UUID = source.id
}

package de.keller.physioai.profile.adapters.jdbc

import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.shared.ProfileId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.stereotype.Repository
import org.springframework.transaction.annotation.Transactional

@SecondaryAdapter
@Transactional(readOnly = true)
@Repository
interface ProfileRepositoryImpl :
    org.springframework.data.repository.Repository<Profile, ProfileId>,
    ProfileRepository {
    override fun findAll(): List<Profile>

    override fun findById(id: ProfileId): Profile?

    @Transactional(readOnly = false)
    @Modifying
    override fun save(profile: Profile): Profile
}

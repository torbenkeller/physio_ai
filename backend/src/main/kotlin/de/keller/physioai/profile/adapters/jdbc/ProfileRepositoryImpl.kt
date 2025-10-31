package de.keller.physioai.profile.adapters.jdbc

import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.shared.ProfileId
import org.jmolecules.architecture.hexagonal.SecondaryAdapter
import org.springframework.data.jdbc.repository.query.Modifying
import org.springframework.transaction.annotation.Transactional

@SecondaryAdapter
@Transactional(readOnly = true)
@org.springframework.stereotype.Repository
@org.jmolecules.ddd.annotation.Repository
interface ProfileRepositoryImpl :
    org.springframework.data.repository.Repository<Profile, ProfileId>,
    ProfileRepository {
    override fun findAll(): List<Profile>

    override fun findById(id: ProfileId): Profile?

    @Transactional(readOnly = false)
    @Modifying
    override fun save(profile: Profile): Profile
}

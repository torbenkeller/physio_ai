package de.keller.physioai.profile.ports

import de.keller.physioai.profile.ProfileId
import de.keller.physioai.profile.domain.Profile
import org.jmolecules.architecture.hexagonal.SecondaryPort

@SecondaryPort
interface ProfileRepository {
    fun findAll(): List<Profile>

    fun findById(id: ProfileId): Profile?

    fun save(profile: Profile): Profile
}

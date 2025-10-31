package de.keller.physioai.profile.ports

import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.shared.ProfileId
import org.jmolecules.architecture.hexagonal.SecondaryPort

@SecondaryPort
interface ProfileRepository {
    fun findAll(): List<Profile>

    fun findById(id: ProfileId): Profile?

    fun save(profile: Profile): Profile
}

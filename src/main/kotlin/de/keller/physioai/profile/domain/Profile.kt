package de.keller.physioai.profile.domain

import de.keller.physioai.profile.ProfileId
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table
import java.util.UUID

@Table("profiles")
data class Profile(
    @Id
    val id: ProfileId,
    val praxisName: String,
    val inhaberName: String,
    val profilePictureUrl: String?,
    val accessToken: UUID = UUID.randomUUID(),
    @Version
    val version: Int = 0,
) {
    fun getCalenderUrl(host: String): String = "$host/profile/${id.id}/kalender?accessToken=$accessToken"
}

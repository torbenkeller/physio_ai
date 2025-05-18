package de.keller.physioai.profile

import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table
import java.util.UUID

data class ProfileId(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): ProfileId = ProfileId(id)

        fun generate(): ProfileId = ProfileId(UUID.randomUUID())
    }
}

@Table("profiles")
data class Profile(
    @Id
    val id: ProfileId,
    val praxisName: String,
    val inhaberName: String,
    val profilePictureUrl: String?,
    @Version
    val version: Int = 0,
)

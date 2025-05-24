package de.keller.physioai.profile.domain

import de.keller.physioai.profile.adapters.api.ProfileDto
import de.keller.physioai.shared.ProfileId
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertAll
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

class ProfileTest {
    @Nested
    inner class ProfileMethodTests {
        @Test
        fun `getCalenderUrl should return correctly formatted URL`() {
            // Arrange
            val host = "http://localhost:8080"
            val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val accessToken = UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef")
            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
                accessToken = accessToken,
            )

            // Act
            val calenderUrl = profile.getCalenderUrl(host)

            // Assert
            assertEquals(
                "http://localhost:8080/profile/d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a/kalender?accessToken=a1b2c3d4-e5f6-7890-1234-567890abcdef",
                calenderUrl,
            )
        }
    }

    @Nested
    inner class ProfileCreationTests {
        @Test
        fun `profile should be created with given values`() {
            // Arrange
            val profileId = ProfileId(UUID.randomUUID())
            val praxisName = "Test Praxis"
            val inhaberName = "Test Owner"
            val profilePictureUrl = "https://example.com/image.jpg"
            val accessToken = UUID.randomUUID()

            // Act
            val profile = Profile(
                id = profileId,
                praxisName = praxisName,
                inhaberName = inhaberName,
                profilePictureUrl = profilePictureUrl,
                accessToken = accessToken,
            )

            // Assert
            assertAll(
                { assertEquals(profileId, profile.id) },
                { assertEquals(praxisName, profile.praxisName) },
                { assertEquals(inhaberName, profile.inhaberName) },
                { assertEquals(profilePictureUrl, profile.profilePictureUrl) },
                { assertEquals(accessToken, profile.accessToken) },
                { assertEquals(0, profile.version) },
            )
        }

        @Test
        fun `profile should be created with default version`() {
            // Arrange
            val profileId = ProfileId(UUID.randomUUID())

            // Act
            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
            )

            // Assert
            assertEquals(0, profile.version)
        }

        @Test
        fun `profile should be created with default random access token`() {
            // Arrange
            val profileId = ProfileId(UUID.randomUUID())

            // Act
            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
            )

            // Assert
            assertNotNull(profile.accessToken)
        }
    }

    @Nested
    inner class ProfileDtoTests {
        @Test
        fun `fromProfile should correctly map all fields`() {
            // Arrange
            val host = "http://localhost:8080"
            val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val accessToken = UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef")
            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = "https://example.com/image.jpg",
                accessToken = accessToken,
            )

            // Act
            val dto = ProfileDto
                .fromProfile(profile, host)

            // Assert
            assertAll(
                { assertEquals(profileId.id, dto.id) },
                { assertEquals("Test Praxis", dto.praxisName) },
                { assertEquals("Test Owner", dto.inhaberName) },
                { assertEquals("https://example.com/image.jpg", dto.profilePictureUrl) },
                {
                    assertEquals(
                        "http://localhost:8080/profile/d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a/kalender?accessToken=a1b2c3d4-e5f6-7890-1234-567890abcdef",
                        dto.calenderUrl,
                    )
                },
            )
        }
    }
}

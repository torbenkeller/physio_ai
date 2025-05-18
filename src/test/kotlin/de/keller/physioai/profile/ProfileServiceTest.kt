package de.keller.physioai.profile

import de.keller.physioai.profile.web.ProfileForm
import de.keller.physioai.shared.web.AggregateNotFoundException
import io.mockk.clearAllMocks
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.junit5.MockKExtension
import io.mockk.slot
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ExtendWith(MockKExtension::class)
class ProfileServiceTest {
    @MockK
    private lateinit var profileRepository: ProfileRepository

    private lateinit var profileService: ProfileService

    @BeforeEach
    fun setUp() {
        clearAllMocks()

        profileService = ProfileService(profileRepository)
    }

    @Nested
    inner class GetProfile {
        @Test
        fun `should return null when no profile exists`() {
            // Arrange
            every { profileRepository.findAll() } returns emptyList()

            // Act
            val result = profileService.getProfile()

            // Assert
            assertNull(result)
            verify { profileRepository.findAll() }
        }

        @Test
        fun `should return the first profile when profiles exist`() {
            // Arrange
            val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val profile = Profile(
                id = profileId,
                praxisName = "Privatpraxis Carsten Huffmeyer",
                inhaberName = "Carsten Huffmeyer",
                profilePictureUrl = null,
                version = 0,
            )

            every { profileRepository.findAll() } returns listOf(profile)

            // Act
            val result = profileService.getProfile()

            // Assert
            assertNotNull(result)
            assertEquals(profileId, result.id)
            assertEquals("Privatpraxis Carsten Huffmeyer", result.praxisName)
            assertEquals("Carsten Huffmeyer", result.inhaberName)
            verify { profileRepository.findAll() }
        }
    }

    @Nested
    inner class CreateProfile {
        @Test
        fun `should create profile successfully`() {
            // Arrange
            val profileForm = ProfileForm(
                praxisName = "Privatpraxis Carsten Huffmeyer",
                inhaberName = "Carsten Huffmeyer",
                profilePictureUrl = null,
            )

            val savedProfileSlot = slot<Profile>()
            every { profileRepository.save(capture(savedProfileSlot)) } answers { savedProfileSlot.captured }

            // Act
            val result = profileService.createProfile(profileForm)

            // Assert
            assertNotNull(result)
            assertEquals("Privatpraxis Carsten Huffmeyer", result.praxisName)
            assertEquals("Carsten Huffmeyer", result.inhaberName)
            assertNull(result.profilePictureUrl)
            verify { profileRepository.save(any()) }
        }

        @Test
        fun `should handle missing fields with default values`() {
            // Arrange
            val profileForm = ProfileForm(
                praxisName = null,
                inhaberName = null,
                profilePictureUrl = "http://example.com/photo.jpg",
            )

            val savedProfileSlot = slot<Profile>()
            every { profileRepository.save(capture(savedProfileSlot)) } answers { savedProfileSlot.captured }

            // Act
            val result = profileService.createProfile(profileForm)

            // Assert
            assertNotNull(result)
            assertEquals("", result.praxisName)
            assertEquals("", result.inhaberName)
            assertEquals("http://example.com/photo.jpg", result.profilePictureUrl)
            verify { profileRepository.save(any()) }
        }
    }

    @Nested
    inner class UpdateProfile {
        @Test
        fun `should throw exception when no profile exists to update`() {
            // Arrange
            val profileForm = ProfileForm(
                praxisName = "Updated Practice Name",
                inhaberName = "Updated Owner Name",
                profilePictureUrl = null,
            )

            every { profileRepository.findById(any()) } returns null

            // Act & Assert
            val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            assertFailsWith<AggregateNotFoundException> {
                profileService.updateProfile(profileId, profileForm)
            }

            verify { profileRepository.findById(profileId) }
            verify(exactly = 0) { profileRepository.save(any()) }
        }

        @Test
        fun `should update existing profile successfully`() {
            // Arrange
            val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val existingProfile = Profile(
                id = profileId,
                praxisName = "Old Practice Name",
                inhaberName = "Old Owner Name",
                profilePictureUrl = null,
                version = 0,
            )

            val profileForm = ProfileForm(
                praxisName = "Privatpraxis Carsten Huffmeyer",
                inhaberName = "Carsten Huffmeyer",
                profilePictureUrl = "http://example.com/new-photo.jpg",
            )

            every { profileRepository.findById(any()) } returns existingProfile

            val savedProfileSlot = slot<Profile>()
            every { profileRepository.save(capture(savedProfileSlot)) } answers { savedProfileSlot.captured }

            // Act
            val result = profileService.updateProfile(profileId, profileForm)

            // Assert
            assertNotNull(result)
            assertEquals(profileId, result.id)
            assertEquals("Privatpraxis Carsten Huffmeyer", result.praxisName)
            assertEquals("Carsten Huffmeyer", result.inhaberName)
            assertEquals("http://example.com/new-photo.jpg", result.profilePictureUrl)

            verify { profileRepository.findById(profileId) }
            verify { profileRepository.save(any()) }
        }

        @Test
        fun `should only update provided fields`() {
            // Arrange
            val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val existingProfile = Profile(
                id = profileId,
                praxisName = "Privatpraxis Carsten Huffmeyer",
                inhaberName = "Carsten Huffmeyer",
                profilePictureUrl = "http://example.com/old-photo.jpg",
                version = 0,
            )

            val profileForm = ProfileForm(
                praxisName = null, // Not updating name
                inhaberName = "Carsten Huffmeyer Jr.", // Only updating owner
                profilePictureUrl = null, // Not updating URL
            )

            every { profileRepository.findById(any()) } returns existingProfile

            val savedProfileSlot = slot<Profile>()
            every { profileRepository.save(capture(savedProfileSlot)) } answers { savedProfileSlot.captured }

            // Act
            val result = profileService.updateProfile(profileId, profileForm)

            // Assert
            assertNotNull(result)
            assertEquals(profileId, result.id)
            assertEquals("Privatpraxis Carsten Huffmeyer", result.praxisName) // Unchanged
            assertEquals("Carsten Huffmeyer Jr.", result.inhaberName) // Updated
            assertEquals("http://example.com/old-photo.jpg", result.profilePictureUrl) // Unchanged

            verify { profileRepository.findById(profileId) }
            verify { profileRepository.save(any()) }
        }
    }
}

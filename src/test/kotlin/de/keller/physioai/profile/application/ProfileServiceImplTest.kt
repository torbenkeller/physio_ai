package de.keller.physioai.profile.application

import de.keller.physioai.profile.ProfileId
import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.profile.ports.ProfileService
import de.keller.physioai.shared.AggregateNotFoundException
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
class ProfileServiceImplTest {
    @MockK
    private lateinit var profileRepository: ProfileRepository

    private lateinit var profileService: ProfileService

    @BeforeEach
    fun setUp() {
        clearAllMocks()

        profileService = ProfileServiceImpl(profileRepository)
    }

    @Nested
    inner class CreateProfile {
        @Test
        fun `should create profile successfully`() {
            // Arrange

            val savedProfileSlot = slot<Profile>()
            every { profileRepository.save(capture(savedProfileSlot)) } answers { savedProfileSlot.captured }

            // Act
            val result = profileService.createProfile(
                praxisName = "Privatpraxis Carsten Huffmeyer",
                inhaberName = "Carsten Huffmeyer",
                profilePictureUrl = null,
            )

            // Assert
            assertNotNull(result)
            assertEquals("Privatpraxis Carsten Huffmeyer", result.praxisName)
            assertEquals("Carsten Huffmeyer", result.inhaberName)
            assertNull(result.profilePictureUrl)
            verify { profileRepository.save(any()) }
        }
    }

    @Nested
    inner class UpdateProfile {
        @Test
        fun `should throw exception when no profile exists to update`() {
            // Arrange

            every { profileRepository.findById(any()) } returns null

            // Act & Assert
            val profileId = ProfileId.fromUUID(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            assertFailsWith<AggregateNotFoundException> {
                profileService.updateProfile(
                    profileId,
                    praxisName = "Updated Practice Name",
                    inhaberName = "Updated Owner Name",
                    profilePictureUrl = null,
                )
            }

            verify { profileRepository.findById(profileId) }
            verify(exactly = 0) { profileRepository.save(any()) }
        }

        @Test
        fun `should update existing profile successfully`() {
            // Arrange
            val profileId = ProfileId.fromUUID(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val existingProfile = Profile(
                id = profileId,
                praxisName = "Old Practice Name",
                inhaberName = "Old Owner Name",
                profilePictureUrl = null,
                version = 0,
            )

            every { profileRepository.findById(any()) } returns existingProfile

            val savedProfileSlot = slot<Profile>()
            every { profileRepository.save(capture(savedProfileSlot)) } answers { savedProfileSlot.captured }

            // Act
            val result = profileService.updateProfile(
                profileId,
                praxisName = "Privatpraxis Carsten Huffmeyer",
                inhaberName = "Carsten Huffmeyer",
                profilePictureUrl = "http://example.com/new-photo.jpg",
            )

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
            val profileId = ProfileId.fromUUID(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
            val existingProfile = Profile(
                id = profileId,
                praxisName = "Privatpraxis Carsten Huffmeyer",
                inhaberName = "Carsten Huffmeyer",
                profilePictureUrl = "http://example.com/old-photo.jpg",
                version = 0,
            )

            every { profileRepository.findById(any()) } returns existingProfile

            val savedProfileSlot = slot<Profile>()
            every { profileRepository.save(capture(savedProfileSlot)) } answers { savedProfileSlot.captured }

            // Act
            val result = profileService.updateProfile(
                profileId,
                praxisName = "Neuer Praxisname",
                inhaberName = "Carsten Huffmeyer Jr.",
                profilePictureUrl = null,
            )

            // Assert
            assertNotNull(result)
            assertEquals(
                profileId,
                result.id,
            )
            assertEquals("Neuer Praxisname", result.praxisName)
            assertEquals("Carsten Huffmeyer Jr.", result.inhaberName)
            assertNull(result.profilePictureUrl)

            verify { profileRepository.findById(profileId) }
            verify { profileRepository.save(any()) }
        }
    }
}

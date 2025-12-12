package de.keller.physioai.profile.application

import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.ExternalCalendarService
import de.keller.physioai.shared.ProfileId
import io.mockk.clearAllMocks
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.junit5.MockKExtension
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.junit.jupiter.api.extension.ExtendWith
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertTrue

@ExtendWith(MockKExtension::class)
class ExternalCalendarServiceImplTest {
    @Nested
    inner class GetExternalEvents {
        @MockK
        private lateinit var profileRepository: ProfileRepository

        private lateinit var externalCalendarService: ExternalCalendarService

        @BeforeEach
        fun setUp() {
            clearAllMocks()
            externalCalendarService = ExternalCalendarServiceImpl(profileRepository)
        }

        @Test
        fun `should throw AggregateNotFoundException when profile not found`() {
            val profileId = ProfileId(UUID.randomUUID())
            every { profileRepository.findById(profileId) } returns null

            assertThrows<AggregateNotFoundException> {
                externalCalendarService.getExternalEvents(
                    profileId,
                    LocalDate.now(),
                    LocalDate.now().plusDays(7),
                )
            }

            verify { profileRepository.findById(profileId) }
        }

        @Test
        fun `should return empty list when no external calendar URL is configured`() {
            val profileId = ProfileId(UUID.randomUUID())
            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
                externalCalendarUrl = null,
            )
            every { profileRepository.findById(profileId) } returns profile

            val result = externalCalendarService.getExternalEvents(
                profileId,
                LocalDate.now(),
                LocalDate.now().plusDays(7),
            )

            assertTrue(result.isEmpty())
            verify { profileRepository.findById(profileId) }
        }

        @Test
        fun `should return empty list when external calendar URL is blank`() {
            val profileId = ProfileId(UUID.randomUUID())
            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
                externalCalendarUrl = "   ",
            )
            every { profileRepository.findById(profileId) } returns profile

            val result = externalCalendarService.getExternalEvents(
                profileId,
                LocalDate.now(),
                LocalDate.now().plusDays(7),
            )

            assertTrue(result.isEmpty())
            verify { profileRepository.findById(profileId) }
        }

        @Test
        fun `should return empty list and not throw when URL is invalid`() {
            val profileId = ProfileId(UUID.randomUUID())
            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
                externalCalendarUrl = "https://invalid-url-that-will-fail.example/calendar.ics",
            )
            every { profileRepository.findById(profileId) } returns profile

            val result = externalCalendarService.getExternalEvents(
                profileId,
                LocalDate.now(),
                LocalDate.now().plusDays(7),
            )

            assertTrue(result.isEmpty())
            verify { profileRepository.findById(profileId) }
        }

        @Test
        fun `should return empty list when URL format is malformed`() {
            val profileId = ProfileId(UUID.randomUUID())
            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
                externalCalendarUrl = "not-a-valid-url",
            )
            every { profileRepository.findById(profileId) } returns profile

            val result = externalCalendarService.getExternalEvents(
                profileId,
                LocalDate.now(),
                LocalDate.now().plusDays(7),
            )

            assertTrue(result.isEmpty())
            verify { profileRepository.findById(profileId) }
        }
    }
}

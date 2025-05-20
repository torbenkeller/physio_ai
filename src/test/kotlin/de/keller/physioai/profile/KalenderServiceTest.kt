package de.keller.physioai.profile

import de.keller.physioai.shared.web.AggregateNotFoundException
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.springframework.security.access.AccessDeniedException
import java.util.UUID
import kotlin.test.assertContains
import kotlin.test.assertTrue

class KalenderServiceTest {
    @Nested
    inner class CalculateKalender {
        @Test
        fun `should throw AggregateNotFoundException when profile not found`() {
            // Arrange
            val profileRepository = mockk<ProfileRepository>()
            val profileId = ProfileId.generate()
            val accessToken = UUID.randomUUID()

            every { profileRepository.findById(profileId) } returns null

            val kalenderService = KalenderService(profileRepository)

            // Act & Assert
            assertThrows<AggregateNotFoundException> {
                kalenderService.calculateKalender(profileId, accessToken)
            }

            verify { profileRepository.findById(profileId) }
        }

        @Test
        fun `should throw AccessDeniedException when access token does not match`() {
            // Arrange
            val profileRepository = mockk<ProfileRepository>()
            val profileId = ProfileId.generate()
            val correctAccessToken = UUID.randomUUID()
            val wrongAccessToken = UUID.randomUUID()

            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
                accessToken = correctAccessToken,
            )

            every { profileRepository.findById(profileId) } returns profile

            val kalenderService = KalenderService(profileRepository)

            // Act & Assert
            assertThrows<AccessDeniedException> {
                kalenderService.calculateKalender(profileId, wrongAccessToken)
            }

            verify { profileRepository.findById(profileId) }
        }

        @Test
        fun `should return correctly formatted iCalendar data when successful`() {
            // Arrange
            val profileRepository = mockk<ProfileRepository>()
            val profileId = ProfileId.generate()
            val accessToken = UUID.randomUUID()

            val profile = Profile(
                id = profileId,
                praxisName = "Test Praxis",
                inhaberName = "Test Owner",
                profilePictureUrl = null,
                accessToken = accessToken,
            )

            every { profileRepository.findById(profileId) } returns profile

            val kalenderService = KalenderService(profileRepository)

            // Act
            val result = kalenderService.calculateKalender(profileId, accessToken)

            // Assert
            verify { profileRepository.findById(profileId) }

            // Check that the result contains expected calendar components
            assertTrue(result.startsWith("BEGIN:VCALENDAR"))
            assertContains(result, "PRODID:-//Physio AI//Kalender//DE")
            assertContains(result, "X-WR-CALNAME:Physio AI Kalender")
            assertContains(result, "X-WR-TIMEZONE:Europe/Berlin")
            assertTrue(result.endsWith("END:VCALENDAR\r\n"))
        }
    }
}

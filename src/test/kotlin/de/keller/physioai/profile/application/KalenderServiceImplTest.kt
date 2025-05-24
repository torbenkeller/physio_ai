package de.keller.physioai.profile.application

import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.profile.ports.KalenderService
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.shared.AggregateNotFoundException
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
import org.springframework.security.access.AccessDeniedException
import java.util.UUID
import kotlin.test.assertContains
import kotlin.test.assertTrue

@ExtendWith(MockKExtension::class)
class KalenderServiceImplTest {
    @Nested
    inner class CalculateKalender {
        @MockK
        private lateinit var profileRepository: ProfileRepository

        private lateinit var kalenderService: KalenderService

        @BeforeEach
        fun setUp() {
            clearAllMocks()

            kalenderService = KalenderServiceImpl(profileRepository)
        }

        @Test
        fun `should throw AggregateNotFoundException when profile not found`() {
            // Arrange
            val profileId = ProfileId.generate()
            val accessToken = UUID.randomUUID()

            every { profileRepository.findById(profileId) } returns null

            // Act & Assert
            assertThrows<AggregateNotFoundException> {
                kalenderService.calculateKalender(profileId, accessToken)
            }

            verify { profileRepository.findById(profileId) }
        }

        @Test
        fun `should throw AccessDeniedException when access token does not match`() {
            // Arrange
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

            // Act & Assert
            assertThrows<AccessDeniedException> {
                kalenderService.calculateKalender(profileId, wrongAccessToken)
            }

            verify { profileRepository.findById(profileId) }
        }

        @Test
        fun `should return correctly formatted iCalendar data when successful`() {
            // Arrange
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

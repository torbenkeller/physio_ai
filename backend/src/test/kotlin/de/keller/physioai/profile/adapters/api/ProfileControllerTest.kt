package de.keller.physioai.profile.adapters.api

import com.ninjasquad.springmockk.MockkBean
import de.keller.physioai.profile.domain.Profile
import de.keller.physioai.profile.ports.KalenderService
import de.keller.physioai.profile.ports.ProfileRepository
import de.keller.physioai.profile.ports.ProfileService
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.ProfileId
import de.keller.physioai.shared.anyValue
import de.keller.physioai.shared.config.SecurityConfig
import io.mockk.every
import io.mockk.verify
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.context.annotation.Import
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import org.springframework.test.web.servlet.result.MockMvcResultMatchers
import java.util.UUID

@Import(SecurityConfig::class)
@WebMvcTest(ProfileController::class)
class ProfileControllerTest {
    @Autowired
    private lateinit var mockMvc: MockMvc

    @MockkBean
    private lateinit var profileService: ProfileService

    @MockkBean
    private lateinit var profileRepository: ProfileRepository

    @MockkBean
    private lateinit var kalenderService: KalenderService

    @Test
    fun `getProfile should return null when no profile exists`() {
        // Arrange
        every { profileRepository.findById(anyValue()) } returns null

        // Act & Assert
        mockMvc
            .perform(MockMvcRequestBuilders.get("/profile"))
            .andExpect(MockMvcResultMatchers.status().isNotFound)

        verify { profileRepository.findById(anyValue()) }
    }

    @Test
    fun `getProfile should return ProfileDto when profile exists`() {
        // Arrange
        val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
        val profile = Profile(
            id = profileId,
            praxisName = "Privatpraxis Carsten Huffmeyer",
            inhaberName = "Carsten Huffmeyer",
            profilePictureUrl = null,
            version = 0,
        )

        every { profileRepository.findById(profileId) } returns profile

        // Act & Asserts
        mockMvc
            .perform(MockMvcRequestBuilders.get("/profile"))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(profileId.id.toString()))
            .andExpect(MockMvcResultMatchers.jsonPath("$.praxisName").value("Privatpraxis Carsten Huffmeyer"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.inhaberName").value("Carsten Huffmeyer"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.profilePictureUrl").doesNotExist())

        verify { profileRepository.findById(profileId) }
    }

    @Test
    fun `createProfile should return ProfileDto with created profile`() {
        // Arrange
        val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))

        val createdProfile = Profile(
            id = profileId,
            praxisName = "Privatpraxis Carsten Huffmeyer",
            inhaberName = "Carsten Huffmeyer",
            profilePictureUrl = null,
            version = 0,
        )

        every { profileService.createProfile(any(), any(), any()) } returns createdProfile

        // Act & Assert
        mockMvc
            .perform(
                MockMvcRequestBuilders
                    .post("/profile")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "praxisName": "Privatpraxis Carsten Huffmeyer",
                            "inhaberName": "Carsten Huffmeyer",
                            "profilePictureUrl": null
                        }
                        """,
                    ),
            ).andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(profileId.id.toString()))
            .andExpect(MockMvcResultMatchers.jsonPath("$.praxisName").value("Privatpraxis Carsten Huffmeyer"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.inhaberName").value("Carsten Huffmeyer"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.profilePictureUrl").doesNotExist())

        verify { profileService.createProfile(any(), any(), any()) }
    }

    @Test
    fun `updateProfile should throw exception when no profile exists to update`() {
        // Arrange
        val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
        every { profileService.updateProfile(profileId, any(), any(), any()) } throws AggregateNotFoundException()

        // Act & Assert
        mockMvc
            .perform(
                MockMvcRequestBuilders
                    .patch("/profile")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "praxisName": "Updated Practice Name",
                            "inhaberName": "Updated Owner Name",
                            "profilePictureUrl": null
                        }
                        """,
                    ),
            ).andExpect(MockMvcResultMatchers.status().isNotFound)

        verify { profileService.updateProfile(profileId, any(), any(), any()) }
    }

    @Test
    fun `updateProfile should return updated ProfileDto when update succeeds`() {
        // Arrange
        val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))

        val updatedProfile = Profile(
            id = profileId,
            praxisName = "Updated Practice Name",
            inhaberName = "Updated Owner Name",
            profilePictureUrl = "http://example.com/new-photo.jpg",
            version = 1,
        )

        every { profileService.updateProfile(profileId, any(), any(), any()) } returns updatedProfile

        // Act & Assert
        mockMvc
            .perform(
                MockMvcRequestBuilders
                    .patch("/profile")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(
                        """
                        {
                            "praxisName": "Updated Practice Name",
                            "inhaberName": "Updated Owner Name",
                            "profilePictureUrl": "http://example.com/new-photo.jpg"
                        }
                        """,
                    ),
            ).andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(profileId.id.toString()))
            .andExpect(MockMvcResultMatchers.jsonPath("$.praxisName").value("Updated Practice Name"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.inhaberName").value("Updated Owner Name"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.profilePictureUrl").value("http://example.com/new-photo.jpg"))

        verify { profileService.updateProfile(profileId, any(), any(), any()) }
    }

    @Test
    fun `getProfile should include calenderUrl in response`() {
        // Arrange
        val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
        val accessToken = UUID.fromString("a1b2c3d4-e5f6-7890-1234-567890abcdef")
        val profile = Profile(
            id = profileId,
            praxisName = "Privatpraxis Carsten Huffmeyer",
            inhaberName = "Carsten Huffmeyer",
            profilePictureUrl = null,
            accessToken = accessToken,
            version = 0,
        )

        every { profileRepository.findById(profileId) } returns profile

        // Act & Assert
        mockMvc
            .perform(MockMvcRequestBuilders.get("/profile"))
            .andExpect(MockMvcResultMatchers.status().isOk)
            .andExpect(MockMvcResultMatchers.content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(MockMvcResultMatchers.jsonPath("$.id").value(profileId.id.toString()))
            .andExpect(MockMvcResultMatchers.jsonPath("$.praxisName").value("Privatpraxis Carsten Huffmeyer"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.inhaberName").value("Carsten Huffmeyer"))
            .andExpect(MockMvcResultMatchers.jsonPath("$.profilePictureUrl").doesNotExist())
            .andExpect(
                MockMvcResultMatchers
                    .jsonPath(
                        "$.calenderUrl",
                    ).value("http://localhost:8080/profile/${profileId.id}/kalender?accessToken=$accessToken"),
            )

        verify { profileRepository.findById(profileId) }
    }
}

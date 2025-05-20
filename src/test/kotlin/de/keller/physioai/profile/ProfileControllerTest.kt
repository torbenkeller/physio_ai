package de.keller.physioai.profile

import com.ninjasquad.springmockk.MockkBean
import de.keller.physioai.config.SecurityConfig
import de.keller.physioai.shared.web.AggregateNotFoundException
import io.mockk.every
import io.mockk.verify
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.context.annotation.Import
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status
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
        every { profileRepository.findById(any()) } returns null

        // Act & Assert
        mockMvc
            .perform(get("/profile"))
            .andExpect(status().isNotFound)

        verify { profileRepository.findById(any()) }
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
            .perform(get("/profile"))
            .andExpect(status().isOk)
            .andExpect(content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(jsonPath("$.id").value(profileId.id.toString()))
            .andExpect(jsonPath("$.praxisName").value("Privatpraxis Carsten Huffmeyer"))
            .andExpect(jsonPath("$.inhaberName").value("Carsten Huffmeyer"))
            .andExpect(jsonPath("$.profilePictureUrl").doesNotExist())

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

        every { profileService.createProfile(any()) } returns createdProfile

        // Act & Assert
        mockMvc
            .perform(
                post("/profile")
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
            ).andExpect(status().isOk)
            .andExpect(content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(jsonPath("$.id").value(profileId.id.toString()))
            .andExpect(jsonPath("$.praxisName").value("Privatpraxis Carsten Huffmeyer"))
            .andExpect(jsonPath("$.inhaberName").value("Carsten Huffmeyer"))
            .andExpect(jsonPath("$.profilePictureUrl").doesNotExist())

        verify { profileService.createProfile(any()) }
    }

    @Test
    fun `updateProfile should throw exception when no profile exists to update`() {
        // Arrange
        val profileId = ProfileId(UUID.fromString("d7e8f9a0-b1c2-3d4e-5f6a-7b8c9d0e1f2a"))
        every { profileService.updateProfile(profileId, any()) } throws AggregateNotFoundException()

        // Act & Assert
        mockMvc
            .perform(
                patch("/profile")
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
            ).andExpect(status().isNotFound)

        verify { profileService.updateProfile(profileId, any()) }
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

        every { profileService.updateProfile(profileId, any()) } returns updatedProfile

        // Act & Assert
        mockMvc
            .perform(
                patch("/profile")
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
            ).andExpect(status().isOk)
            .andExpect(content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(jsonPath("$.id").value(profileId.id.toString()))
            .andExpect(jsonPath("$.praxisName").value("Updated Practice Name"))
            .andExpect(jsonPath("$.inhaberName").value("Updated Owner Name"))
            .andExpect(jsonPath("$.profilePictureUrl").value("http://example.com/new-photo.jpg"))

        verify { profileService.updateProfile(profileId, any()) }
    }
}

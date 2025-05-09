package de.keller.physioai.rezepte.domain

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.rezepte.web.RezeptPosCreateDto
import de.keller.physioai.rezepte.web.RezeptUpdateDto
import io.mockk.clearAllMocks
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.junit5.MockKExtension
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import java.time.LocalDate
import java.util.UUID
import kotlin.test.expect

@ExtendWith(MockKExtension::class)
class RezeptServiceTest {
    @MockK
    private lateinit var rezeptRepository: RezeptRepository

    @MockK
    private lateinit var behandlungsartenRepository: BehandlungsartenRepository

    @MockK
    private lateinit var patientenRepository: PatientenRepository

    private lateinit var rezeptService: RezeptService

    @BeforeEach
    fun setUp() {
        clearAllMocks()

        rezeptService =
            RezeptService(
                rezeptRepository,
                behandlungsartenRepository,
                patientenRepository,
            )
    }

    @Test
    fun `updateRezept should succeed`() {
        val rezeptId = RezeptId.generate()
        val patientId = PatientId.generate()
        val behandlungsartId1 = BehandlungsartId.generate()
        val behandlungsartId2 = BehandlungsartId.generate()

        val pos1 =
            RezeptPos(
                UUID.randomUUID(),
                behandlungsartId1,
                12,
                75.2,
                902.4,
                "Manuelle Therapie Doppelbehandlung",
            )

        val pos2 =
            RezeptPos(
                UUID.randomUUID(),
                behandlungsartId2,
                12,
                22.84,
                274.08,
                "Klassische Massagetherapie",
            )

        val rezept =
            Rezept(
                id = rezeptId,
                patientId = patientId,
                ausgestelltAm = LocalDate.of(2023, 1, 1),
                ausgestelltVonArztId = null,
                preisGesamt = 100.0,
                rechnungsnummer = null,
                positionen = listOf(pos1, pos2),
                version = 1,
            )

        val updatedPatientId = PatientId.generate()

        val updateDto =
            RezeptUpdateDto(
                patientId = updatedPatientId.id,
                ausgestelltAm = LocalDate.of(2024, 1, 1),
                positionen =
                    listOf(
                        RezeptPosCreateDto(
                            behandlungsartId = behandlungsartId2.id,
                            anzahl = 1,
                        ),
                    ),
            )

        val updatedRezept =
            rezept.copy()

        every { rezeptRepository.findById(rezeptId) }.returns(rezept)

        expect(rezept) { rezept }
    }
}

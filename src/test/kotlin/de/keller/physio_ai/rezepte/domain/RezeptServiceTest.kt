package de.keller.physio_ai.rezepte.domain

import de.keller.physio_ai.patienten.PatientId
import de.keller.physio_ai.patienten.PatientenRepository
import de.keller.physio_ai.rezepte.web.RezeptPosCreateDto
import de.keller.physio_ai.rezepte.web.RezeptUpdateDto
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.mockito.Mockito.*
import java.time.LocalDate
import java.util.*

class RezeptServiceTest {

    private lateinit var rezeptRepository: RezeptRepository
    private lateinit var behandlungsartenRepository: BehandlungsartenRepository
    private lateinit var patientenRepository: PatientenRepository
    private lateinit var rezeptService: RezeptService;

    @BeforeEach
    fun setUp() {
        rezeptRepository = mock(RezeptRepository::class.java)
        behandlungsartenRepository = mock(BehandlungsartenRepository::class.java)
        patientenRepository = mock(PatientenRepository::class.java)

        rezeptService = RezeptService(
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

        val pos1 = RezeptPos(
            UUID.randomUUID(),
            behandlungsartId1,
            12,
            75.2,
            902.4,
            "Manuelle Therapie Doppelbehandlung",
        )

        val pos2 = RezeptPos(
            UUID.randomUUID(),
            behandlungsartId2,
            12,
            22.84,
            274.08,
            "Klassische Massagetherapie",
        )

        val rezept = Rezept(
            id = rezeptId,
            patientId = patientId,
            ausgestelltAm = LocalDate.of(2023, 1, 1),
            ausgestelltVonArztId = null,
            preisGesamt = 100.0,
            rechnungsnummer = null,
            positionen = listOf(pos1, pos2),
            version = 1
        )

        val updatedPatientId = PatientId.generate()

        val updateDto = RezeptUpdateDto(
            patientId = updatedPatientId.id,
            ausgestelltAm = LocalDate.of(2024, 1, 1),
            positionen = listOf(
                RezeptPosCreateDto(
                    behandlungsartId = behandlungsartId2.id,
                    anzahl = 1
                )
            )
        )

        val updatedRezept = rezept.copy(

        )

        doAnswer { rezept }
            .`when`(rezeptRepository.findById(rezeptId))

    }
}
package de.keller.physioai.rezepte.domain

import de.keller.physioai.patienten.PatientId
import org.junit.jupiter.api.Test
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertNotEquals

class RezeptTest {
    private val patientId = PatientId.fromUUID(UUID.randomUUID())
    private val ausgestelltAm = LocalDate.of(2023, 1, 1)
    private val behandlungsartId = BehandlungsartId.generate()

    @Test
    fun `createNew should create a valid rezept`() {
        // Arrange
        val posSource = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = behandlungsartId,
            behandlungsartName = "Manuelle Therapie",
            behandlungsartPreis = 75.2,
            anzahl = 6,
        )

        // Act
        val rezept = Rezept.createNew(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null,
            posSources = listOf(posSource),
        )

        // Assert
        assertEquals(patientId, rezept.patientId)
        assertEquals(ausgestelltAm, rezept.ausgestelltAm)
        assertEquals(1, rezept.positionen.size)
        assertEquals(6, rezept.positionen[0].anzahl)
        assertEquals(75.2 * 6, rezept.preisGesamt)
        assertEquals(0, rezept.behandlungen.size)
    }

    @Test
    fun `createNew should throw when no positions are provided`() {
        // Act & Assert
        assertFailsWith<IllegalArgumentException> {
            Rezept.createNew(
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                posSources = emptyList(),
            )
        }
    }

    @Test
    fun `update should update the rezept correctly`() {
        // Arrange
        val behandlungsart1 = Behandlungsart(
            id = behandlungsartId,
            name = "Manuelle Therapie",
            preis = 75.2,
        )

        val posSource1 = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = behandlungsartId,
            behandlungsartName = "Manuelle Therapie",
            behandlungsartPreis = 75.2,
            anzahl = 6,
        )

        val rezept = Rezept.createNew(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null,
            posSources = listOf(posSource1),
        )

        val newPatientId = PatientId.generate()
        val newAusgestelltAm = LocalDate.of(2023, 2, 1)
        val newBehandlungsartId = BehandlungsartId.generate()

        val newPosSource = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = newBehandlungsartId,
            behandlungsartName = "Klassische Massagetherapie",
            behandlungsartPreis = 22.84,
            anzahl = 8,
        )

        // Act
        val updatedRezept = rezept.update(
            patientId = newPatientId,
            ausgestelltAm = newAusgestelltAm,
            ausgestelltVonArztId = null,
            rechnungsnummer = "R12345",
            posSources = listOf(newPosSource),
        )

        // Assert
        assertEquals(newPatientId, updatedRezept.patientId)
        assertEquals(newAusgestelltAm, updatedRezept.ausgestelltAm)
        assertEquals("R12345", updatedRezept.rechnungsnummer)
        assertEquals(1, updatedRezept.positionen.size)
        assertEquals(8, updatedRezept.positionen[0].anzahl)
        assertEquals(22.84 * 8, updatedRezept.preisGesamt)
        assertEquals(rezept.behandlungen, updatedRezept.behandlungen) // Behandlungen should remain unchanged
    }

    @Test
    fun `update should throw when no positions are provided`() {
        // Arrange
        val createRezeptPosData = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = behandlungsartId,
            behandlungsartName = "Manuelle Therapie",
            behandlungsartPreis = 75.2,
            anzahl = 6,
        )
        val posSource = createRezeptPosData

        val rezept = Rezept.createNew(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null,
            posSources = listOf(posSource),
        )

        // Act & Assert
        assertFailsWith<IllegalArgumentException> {
            rezept.update(
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = null,
                rechnungsnummer = null,
                posSources = emptyList(),
            )
        }
    }

    @Test
    fun `addBehandlung should add a behandlung to the rezept`() {
        // Arrange
        val posSource = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = behandlungsartId,
            behandlungsartName = "Manuelle Therapie",
            behandlungsartPreis = 75.2,
            anzahl = 6,
        )

        val rezept = Rezept.createNew(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null,
            posSources = listOf(posSource),
        )

        val startZeit = LocalDateTime.of(2023, 5, 15, 10, 0)
        val endZeit = LocalDateTime.of(2023, 5, 15, 11, 0)

        // Act
        val updatedRezept = rezept.addBehandlung(startZeit, endZeit)

        // Assert
        assertEquals(1, updatedRezept.behandlungen.size)
        assertEquals(startZeit, updatedRezept.behandlungen[0].startZeit)
        assertEquals(endZeit, updatedRezept.behandlungen[0].endZeit)
        assertEquals(rezept.id, updatedRezept.behandlungen[0].rezeptId)

        // Ensure rezept itself was not modified (immutability)
        assertEquals(0, rezept.behandlungen.size)
    }

    @Test
    fun `addBehandlung should sort behandlungen by startZeit`() {
        // Arrange
        val posSource = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = behandlungsartId,
            behandlungsartName = "Manuelle Therapie",
            behandlungsartPreis = 75.2,
            anzahl = 6,
        )

        val rezept = Rezept.createNew(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null,
            posSources = listOf(posSource),
        )

        // First add a behandlung at 2 PM
        val startZeit1 = LocalDateTime.of(2023, 5, 15, 14, 0)
        val endZeit1 = LocalDateTime.of(2023, 5, 15, 15, 0)
        val rezeptWithOne = rezept.addBehandlung(startZeit1, endZeit1)

        // Then add a behandlung at 10 AM (earlier)
        val startZeit2 = LocalDateTime.of(2023, 5, 15, 10, 0)
        val endZeit2 = LocalDateTime.of(2023, 5, 15, 11, 0)

        // Act
        val rezeptWithTwo = rezeptWithOne.addBehandlung(startZeit2, endZeit2)

        // Assert
        assertEquals(2, rezeptWithTwo.behandlungen.size)

        // Verify the behandlungen are sorted by startZeit
        assertEquals(startZeit2, rezeptWithTwo.behandlungen[0].startZeit, "First behandlung should be the 10 AM one")
        assertEquals(startZeit1, rezeptWithTwo.behandlungen[1].startZeit, "Second behandlung should be the 2 PM one")
    }

    @Test
    fun `removeBehandlung should return unchanged rezept when behandlung not found`() {
        // Arrange
        val behandlungsart = Behandlungsart(
            id = behandlungsartId,
            name = "Manuelle Therapie",
            preis = 75.2,
        )

        val posSource = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = behandlungsartId,
            behandlungsartName = "Manuelle Therapie",
            behandlungsartPreis = 75.2,
            anzahl = 6,
        )

        val rezept = Rezept.createNew(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null,
            posSources = listOf(posSource),
        )

        val startZeit = LocalDateTime.of(2023, 5, 15, 10, 0)
        val endZeit = LocalDateTime.of(2023, 5, 15, 11, 0)
        val rezeptWithBehandlung = rezept.addBehandlung(startZeit, endZeit)

        val nonExistentBehandlungId = UUID.randomUUID()

        // Act
        val result = rezeptWithBehandlung.removeBehandlung(nonExistentBehandlungId)

        // Assert
        assertEquals(rezeptWithBehandlung, result)
        assertEquals(1, result.behandlungen.size)
    }

    @Test
    fun `removeBehandlung should remove the behandlung when found`() {
        // Arrange
        val posSource = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = behandlungsartId,
            behandlungsartName = "Manuelle Therapie",
            behandlungsartPreis = 75.2,
            anzahl = 6,
        )

        val rezept = Rezept.createNew(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null,
            posSources = listOf(posSource),
        )

        val startZeit = LocalDateTime.of(2023, 5, 15, 10, 0)
        val endZeit = LocalDateTime.of(2023, 5, 15, 11, 0)
        val rezeptWithBehandlung = rezept.addBehandlung(startZeit, endZeit)

        val behandlungId = rezeptWithBehandlung.behandlungen[0].id

        // Act
        val result = rezeptWithBehandlung.removeBehandlung(behandlungId)

        // Assert
        assertNotEquals(rezeptWithBehandlung, result)
        assertEquals(0, result.behandlungen.size)
    }

    @Test
    fun `removeBehandlung should maintain order of remaining behandlungen`() {
        // Arrange
        val posSource = Rezept.Companion.CreateRezeptPosData(
            behandlungsartId = behandlungsartId,
            behandlungsartName = "Manuelle Therapie",
            behandlungsartPreis = 75.2,
            anzahl = 6,
        )

        val rezept = Rezept.createNew(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            ausgestelltVonArztId = null,
            posSources = listOf(posSource),
        )

        // Add three behandlungen in different order
        val startZeit1 = LocalDateTime.of(2023, 5, 15, 14, 0) // 2 PM
        val endZeit1 = LocalDateTime.of(2023, 5, 15, 15, 0)

        val startZeit2 = LocalDateTime.of(2023, 5, 15, 10, 0) // 10 AM
        val endZeit2 = LocalDateTime.of(2023, 5, 15, 11, 0)

        val startZeit3 = LocalDateTime.of(2023, 5, 15, 16, 0) // 4 PM
        val endZeit3 = LocalDateTime.of(2023, 5, 15, 17, 0)

        val rezeptWithOne = rezept.addBehandlung(startZeit1, endZeit1)
        val rezeptWithTwo = rezeptWithOne.addBehandlung(startZeit2, endZeit2)
        val rezeptWithThree = rezeptWithTwo.addBehandlung(startZeit3, endZeit3)

        // Verify initial sort order (10 AM, 2 PM, 4 PM)
        assertEquals(startZeit2, rezeptWithThree.behandlungen[0].startZeit)
        assertEquals(startZeit1, rezeptWithThree.behandlungen[1].startZeit)
        assertEquals(startZeit3, rezeptWithThree.behandlungen[2].startZeit)

        // Remove the middle behandlung (2 PM)
        val middleBehandlungId = rezeptWithThree.behandlungen[1].id

        // Act
        val result = rezeptWithThree.removeBehandlung(middleBehandlungId)

        // Assert
        assertEquals(2, result.behandlungen.size)

        // Verify the remaining behandlungen are still sorted correctly
        assertEquals(startZeit2, result.behandlungen[0].startZeit, "First behandlung should be the 10 AM one")
        assertEquals(startZeit3, result.behandlungen[1].startZeit, "Second behandlung should be the 4 PM one")
    }
}

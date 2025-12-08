package de.keller.physioai.rezepte.domain

import de.keller.physioai.shared.BehandlungsartId
import de.keller.physioai.shared.PatientId
import org.junit.jupiter.api.Test
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class RezeptTest {
    private val patientId = PatientId(UUID.randomUUID())
    private val ausgestelltAm = LocalDate.of(2023, 1, 1)
    private val behandlungsartId = BehandlungsartId(UUID.randomUUID())

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

        val newPatientId = PatientId(UUID.randomUUID())
        val newAusgestelltAm = LocalDate.of(2023, 2, 1)
        val newBehandlungsartId = BehandlungsartId(UUID.randomUUID())

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
        // Other properties should be updated correctly
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
}

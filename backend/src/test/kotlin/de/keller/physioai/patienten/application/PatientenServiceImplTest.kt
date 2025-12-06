package de.keller.physioai.patienten.application

import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.patienten.ports.PatientenRepository
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import java.time.LocalDate
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

class PatientenServiceImplTest {
    private val patientenRepository: PatientenRepository = mockk()
    private val patientenService = PatientenServiceImpl(patientenRepository)

    @Test
    fun `should create patient with valid data`() {
        // Given - valid patient data
        val expectedPatient = PatientAggregate.create(
            titel = "Dr.",
            vorname = "Max",
            nachname = "Mustermann",
            strasse = "Musterstraße",
            hausnummer = "1",
            plz = "12345",
            stadt = "Musterstadt",
            telMobil = "0123456789",
            telFestnetz = "0987654321",
            email = "max@example.com",
            geburtstag = LocalDate.of(1990, 1, 1),
            behandlungenProRezept = null,
        )

        every { patientenRepository.save(any()) } returns expectedPatient

        // When - creating patient
        val result = patientenService.createPatient(
            titel = "Dr.",
            vorname = "Max",
            nachname = "Mustermann",
            strasse = "Musterstraße",
            hausnummer = "1",
            plz = "12345",
            stadt = "Musterstadt",
            telMobil = "0123456789",
            telFestnetz = "0987654321",
            email = "max@example.com",
            geburtstag = LocalDate.of(1990, 1, 1),
            behandlungenProRezept = null,
        )

        // Then - patient should be created successfully
        assertNotNull(result)
        assertEquals("Max", result.vorname)
        assertEquals("Mustermann", result.nachname)
        verify { patientenRepository.save(any()) }
    }

    @Test
    fun `should throw IllegalArgumentException when vorname is empty`() {
        // Given - empty vorname
        // When/Then - creating patient with empty vorname should throw exception
        assertThrows<IllegalArgumentException> {
            patientenService.createPatient(
                titel = null,
                vorname = "", // empty vorname
                nachname = "Mustermann",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `should throw IllegalArgumentException when nachname is empty`() {
        // Given - empty nachname
        // When/Then - creating patient with empty nachname should throw exception
        assertThrows<IllegalArgumentException> {
            patientenService.createPatient(
                titel = null,
                vorname = "Max",
                nachname = "", // empty nachname
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `should throw IllegalArgumentException when both vorname and nachname are empty`() {
        // Given - both names empty
        // When/Then - creating patient with both names empty should throw exception
        assertThrows<IllegalArgumentException> {
            patientenService.createPatient(
                titel = null,
                vorname = "", // empty vorname
                nachname = "", // empty nachname
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `should throw IllegalArgumentException when vorname is blank`() {
        // Given - blank vorname (only whitespace)
        // When/Then - creating patient with blank vorname should throw exception
        assertThrows<IllegalArgumentException> {
            patientenService.createPatient(
                titel = null,
                vorname = "   ", // blank vorname
                nachname = "Mustermann",
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }

    @Test
    fun `should throw IllegalArgumentException when nachname is blank`() {
        // Given - blank nachname (only whitespace)
        // When/Then - creating patient with blank nachname should throw exception
        assertThrows<IllegalArgumentException> {
            patientenService.createPatient(
                titel = null,
                vorname = "Max",
                nachname = "   ", // blank nachname
                strasse = null,
                hausnummer = null,
                plz = null,
                stadt = null,
                telMobil = null,
                telFestnetz = null,
                email = null,
                geburtstag = null,
                behandlungenProRezept = null,
            )
        }
    }
}

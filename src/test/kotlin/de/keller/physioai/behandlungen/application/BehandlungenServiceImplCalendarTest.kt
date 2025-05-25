package de.keller.physioai.behandlungen.application

import de.keller.physioai.behandlungen.TestPatient
import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungenRepository
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID

class BehandlungenServiceImplCalendarTest {
    private val behandlungenRepository = mockk<BehandlungenRepository>()
    private val patientenRepository = mockk<PatientenRepository>()
    private val service = BehandlungenServiceImpl(behandlungenRepository, patientenRepository)

    @Test
    fun `should group treatments correctly by dates with LocalDate keys`() {
        // Arrange
        val date = LocalDate.of(2024, 1, 15) // Monday

        val mondayPatientId = PatientId(UUID.randomUUID())
        val wednesdayPatientId = PatientId(UUID.randomUUID())
        val fridayPatientId = PatientId(UUID.randomUUID())

        val mondayTreatment = BehandlungAggregate(
            id = BehandlungId(UUID.randomUUID()),
            patientId = mondayPatientId,
            startZeit = LocalDateTime.of(2024, 1, 15, 10, 0), // Monday
            endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
            rezeptId = null,
            version = 0,
        )

        val wednesdayTreatment = BehandlungAggregate(
            id = BehandlungId(UUID.randomUUID()),
            patientId = wednesdayPatientId,
            startZeit = LocalDateTime.of(2024, 1, 17, 14, 0), // Wednesday
            endZeit = LocalDateTime.of(2024, 1, 17, 15, 0),
            rezeptId = null,
            version = 0,
        )

        val fridayTreatment = BehandlungAggregate(
            id = BehandlungId(UUID.randomUUID()),
            patientId = fridayPatientId,
            startZeit = LocalDateTime.of(2024, 1, 19, 9, 0), // Friday
            endZeit = LocalDateTime.of(2024, 1, 19, 10, 0),
            rezeptId = null,
            version = 0,
        )

        val mondayPatient = TestPatient(
            id = mondayPatientId,
            titel = null,
            vorname = "Monday",
            nachname = "Patient",
            strasse = null,
            hausnummer = null,
            plz = null,
            stadt = null,
            telMobil = null,
            telFestnetz = null,
            email = null,
            geburtstag = null,
        )

        val wednesdayPatient = TestPatient(
            id = wednesdayPatientId,
            titel = null,
            vorname = "Wednesday",
            nachname = "Patient",
            strasse = null,
            hausnummer = null,
            plz = null,
            stadt = null,
            telMobil = null,
            telFestnetz = null,
            email = null,
            geburtstag = null,
        )

        val fridayPatient = TestPatient(
            id = fridayPatientId,
            titel = null,
            vorname = "Friday",
            nachname = "Patient",
            strasse = null,
            hausnummer = null,
            plz = null,
            stadt = null,
            telMobil = null,
            telFestnetz = null,
            email = null,
            geburtstag = null,
        )

        every {
            behandlungenRepository.findAllByDateRange(
                LocalDateTime.of(2024, 1, 15, 0, 0, 0),
                LocalDateTime.of(2024, 1, 21, 23, 59, 59),
            )
        } returns listOf(mondayTreatment, wednesdayTreatment, fridayTreatment)

        every {
            patientenRepository.findAllByIdIn(setOf(mondayPatientId, wednesdayPatientId, fridayPatientId))
        } returns listOf(mondayPatient, wednesdayPatient, fridayPatient)

        // Act
        val result = service.getWeeklyCalendar(date)

        // Assert - Test expects Map<LocalDate, List<GetWeeklyCalendarBehandlungResponse>>
        assertEquals(7, result.size)
        assertEquals(1, result[LocalDate.of(2024, 1, 15)]?.size) // Monday
        assertEquals(0, result[LocalDate.of(2024, 1, 16)]?.size) // Tuesday
        assertEquals(1, result[LocalDate.of(2024, 1, 17)]?.size) // Wednesday
        assertEquals(0, result[LocalDate.of(2024, 1, 18)]?.size) // Thursday
        assertEquals(1, result[LocalDate.of(2024, 1, 19)]?.size) // Friday
        assertEquals(0, result[LocalDate.of(2024, 1, 20)]?.size) // Saturday
        assertEquals(0, result[LocalDate.of(2024, 1, 21)]?.size) // Sunday

        assertEquals(mondayTreatment, result[LocalDate.of(2024, 1, 15)]?.first()?.behandlungAggregate)
        assertEquals(wednesdayTreatment, result[LocalDate.of(2024, 1, 17)]?.first()?.behandlungAggregate)
        assertEquals(fridayTreatment, result[LocalDate.of(2024, 1, 19)]?.first()?.behandlungAggregate)

        verify {
            behandlungenRepository.findAllByDateRange(
                LocalDateTime.of(2024, 1, 15, 0, 0, 0),
                LocalDateTime.of(2024, 1, 21, 23, 59, 59),
            )
        }
    }

    @Test
    fun `should return empty lists for all days when no treatments exist`() {
        // Arrange
        val date = LocalDate.of(2024, 1, 15) // Monday

        every {
            behandlungenRepository.findAllByDateRange(
                LocalDateTime.of(2024, 1, 15, 0, 0, 0),
                LocalDateTime.of(2024, 1, 21, 23, 59, 59),
            )
        } returns emptyList()

        every {
            patientenRepository.findAllByIdIn(emptySet())
        } returns emptyList()

        // Act
        val result = service.getWeeklyCalendar(date)

        // Assert
        assertEquals(7, result.size)
        result.values.forEach { treatments ->
            assertEquals(0, treatments.size)
        }
    }

    @Test
    fun `should calculate correct week boundaries for different dates`() {
        // Arrange - Test with a Wednesday
        val date = LocalDate.of(2024, 1, 17) // Wednesday

        every {
            behandlungenRepository.findAllByDateRange(
                LocalDateTime.of(2024, 1, 15, 0, 0, 0), // Should still be Monday
                LocalDateTime.of(2024, 1, 21, 23, 59, 59), // Should still be Sunday
            )
        } returns emptyList()

        every {
            patientenRepository.findAllByIdIn(emptySet())
        } returns emptyList()

        // Act
        service.getWeeklyCalendar(date)

        // Assert
        verify {
            behandlungenRepository.findAllByDateRange(
                LocalDateTime.of(2024, 1, 15, 0, 0, 0), // Monday start
                LocalDateTime.of(2024, 1, 21, 23, 59, 59), // Sunday end
            )
        }
    }

    @Test
    fun `should enrich treatments with patient data in weekly calendar`() {
        // Arrange
        val date = LocalDate.of(2024, 1, 15) // Monday

        val mondayPatientId = PatientId(UUID.randomUUID())
        val wednesdayPatientId = PatientId(UUID.randomUUID())

        val mondayTreatment = BehandlungAggregate(
            id = BehandlungId(UUID.randomUUID()),
            patientId = mondayPatientId,
            startZeit = LocalDateTime.of(2024, 1, 15, 10, 0),
            endZeit = LocalDateTime.of(2024, 1, 15, 11, 0),
            rezeptId = null,
            version = 0,
        )

        val wednesdayTreatment = BehandlungAggregate(
            id = BehandlungId(UUID.randomUUID()),
            patientId = wednesdayPatientId,
            startZeit = LocalDateTime.of(2024, 1, 17, 14, 0),
            endZeit = LocalDateTime.of(2024, 1, 17, 15, 0),
            rezeptId = null,
            version = 0,
        )

        val mondayPatient = TestPatient(
            id = mondayPatientId,
            titel = null,
            vorname = "John",
            nachname = "Doe",
            strasse = null,
            hausnummer = null,
            plz = null,
            stadt = null,
            telMobil = null,
            telFestnetz = null,
            email = null,
            geburtstag = null,
        )

        val wednesdayPatient = TestPatient(
            id = wednesdayPatientId,
            titel = null,
            vorname = "Jane",
            nachname = "Smith",
            strasse = null,
            hausnummer = null,
            plz = null,
            stadt = null,
            telMobil = null,
            telFestnetz = null,
            email = null,
            geburtstag = null,
        )

        every {
            behandlungenRepository.findAllByDateRange(
                LocalDateTime.of(2024, 1, 15, 0, 0, 0),
                LocalDateTime.of(2024, 1, 21, 23, 59, 59),
            )
        } returns listOf(mondayTreatment, wednesdayTreatment)

        every {
            patientenRepository.findAllByIdIn(setOf(mondayPatientId, wednesdayPatientId))
        } returns listOf(mondayPatient, wednesdayPatient)

        // Act
        val result = service.getWeeklyCalendar(date)

        // Assert - Verify enriched response structure
        assertEquals(7, result.size)
        assertEquals(1, result[LocalDate.of(2024, 1, 15)]?.size) // Monday
        assertEquals(1, result[LocalDate.of(2024, 1, 17)]?.size) // Wednesday

        // Verify Monday enriched data
        val mondayResponse = result[LocalDate.of(2024, 1, 15)]?.first()!!
        assertEquals(mondayTreatment, mondayResponse.behandlungAggregate)
        assertEquals("John", mondayResponse.patient.vorname)
        assertEquals("Doe", mondayResponse.patient.nachname)

        // Verify Wednesday enriched data
        val wednesdayResponse = result[LocalDate.of(2024, 1, 17)]?.first()!!
        assertEquals(wednesdayTreatment, wednesdayResponse.behandlungAggregate)
        assertEquals("Jane", wednesdayResponse.patient.vorname)
        assertEquals("Smith", wednesdayResponse.patient.nachname)

        verify {
            behandlungenRepository.findAllByDateRange(
                LocalDateTime.of(2024, 1, 15, 0, 0, 0),
                LocalDateTime.of(2024, 1, 21, 23, 59, 59),
            )
        }

        verify {
            patientenRepository.findAllByIdIn(any())
        }
    }
}

package de.keller.physioai.patienten

import de.keller.physioai.patienten.web.PatientDto
import org.apache.logging.log4j.util.Strings
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@RestController
@RequestMapping("/patienten")
class PatientenController
    @Autowired
    constructor(
        private val repository: PatientenRepository,
    ) {
        @GetMapping
        fun getPatienten(): List<PatientDto> =
            repository
                .findAll()
                .map { PatientDto.fromPatient(it) }
                .sortedBy { it.nachname }

        @PostMapping
        fun createPatient(
            @RequestBody patientForm: PatientForm,
        ): PatientDto {
            val p =
                Patient(
                    id = PatientId.generate(),
                    titel = patientForm.titel,
                    vorname = patientForm.vorname ?: "",
                    nachname = patientForm.nachname ?: "",
                    strasse = patientForm.strasse,
                    hausnummer = patientForm.hausnummer,
                    plz = patientForm.plz,
                    stadt = patientForm.stadt,
                    telMobil = patientForm.telMobil,
                    telFestnetz = patientForm.telFestnetz,
                    email = patientForm.email,
                    geburtstag = patientForm.geburtstag,
                )

            repository.save(p)

            return PatientDto.fromPatient(p)
        }

        @PatchMapping("/{id}")
        fun updatePatient(
            @PathVariable id: UUID,
            @RequestBody patientForm: PatientForm,
        ): PatientDto? {
            val patient = repository.findById(PatientId.fromUUID(id)) ?: return null

            val updatedPatient =
                patient.copy(
                    titel = patientForm.titel,
                    vorname = patientForm.vorname ?: "",
                    nachname = patientForm.nachname ?: "",
                    strasse = Strings.trimToNull(patientForm.strasse),
                    hausnummer = Strings.trimToNull(patientForm.hausnummer),
                    plz = Strings.trimToNull(patientForm.plz),
                    stadt = Strings.trimToNull(patientForm.stadt),
                    telMobil = Strings.trimToNull(patientForm.telMobil),
                    telFestnetz = Strings.trimToNull(patientForm.telFestnetz),
                    email = Strings.trimToNull(patientForm.email),
                    geburtstag = patientForm.geburtstag,
                )

            repository.save(updatedPatient)

            return PatientDto.fromPatient(updatedPatient)
        }

        @DeleteMapping("/{id}")
        fun deletePatient(
            @PathVariable id: UUID,
        ) {
            repository.deleteById(PatientId.fromUUID(id))
        }
    }

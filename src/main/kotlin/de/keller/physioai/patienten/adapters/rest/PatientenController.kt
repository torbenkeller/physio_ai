package de.keller.physioai.patienten.adapters.rest

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.patienten.ports.PatientenRepository
import de.keller.physioai.patienten.ports.PatientenService
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
        private val patientenService: PatientenService,
    ) {
        @GetMapping
        fun getPatienten(): List<PatientDto> =
            repository
                .findAll()
                .map { PatientDto.fromPatient(it) }
                .sortedBy { it.nachname }

        @PostMapping
        fun createPatient(
            @RequestBody patientForm: PatientFormDto,
        ): PatientDto =
            patientenService
                .createPatient(
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
                ).let { PatientDto.fromPatient(it) }

        @PatchMapping("/{id}")
        fun updatePatient(
            @PathVariable id: UUID,
            @RequestBody patientForm: PatientFormDto,
        ): PatientDto? {
            val updatedPatient = patientenService.updatePatient(
                id = PatientId.fromUUID(id),
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

            return updatedPatient?.let { PatientDto.fromPatient(it) }
        }

        @DeleteMapping("/{id}")
        fun deletePatient(
            @PathVariable id: UUID,
        ) {
            repository.deleteById(PatientId.Companion.fromUUID(id))
        }
    }

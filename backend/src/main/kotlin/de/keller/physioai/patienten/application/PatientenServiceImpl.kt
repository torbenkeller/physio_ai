package de.keller.physioai.patienten.application

import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.patienten.ports.PatientenRepository
import de.keller.physioai.patienten.ports.PatientenService
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.PatientId
import org.jmolecules.architecture.hexagonal.Application
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate

@Application
@Service
class PatientenServiceImpl(
    private val patientenRepository: PatientenRepository,
) : PatientenService {
    override fun createPatient(
        titel: String?,
        vorname: String,
        nachname: String,
        strasse: String?,
        hausnummer: String?,
        plz: String?,
        stadt: String?,
        telMobil: String?,
        telFestnetz: String?,
        email: String?,
        geburtstag: LocalDate?,
        behandlungenProRezept: Int?,
    ): PatientAggregate {
        // Validate required fields
        require(vorname.isNotBlank()) { "Vorname darf nicht leer sein" }
        require(nachname.isNotBlank()) { "Nachname darf nicht leer sein" }
        val p = PatientAggregate.create(
            titel = titel,
            vorname = vorname,
            nachname = nachname,
            strasse = strasse,
            hausnummer = hausnummer,
            plz = plz,
            stadt = stadt,
            telMobil = telMobil,
            telFestnetz = telFestnetz,
            email = email,
            geburtstag = geburtstag,
            behandlungenProRezept = behandlungenProRezept,
        )

        return patientenRepository.save(p)
    }

    @Transactional
    override fun updatePatient(
        id: PatientId,
        titel: String?,
        vorname: String,
        nachname: String,
        strasse: String?,
        hausnummer: String?,
        plz: String?,
        stadt: String?,
        telMobil: String?,
        telFestnetz: String?,
        email: String?,
        geburtstag: LocalDate?,
        behandlungenProRezept: Int?,
    ): PatientAggregate {
        // Validate required fields
        require(vorname.isNotBlank()) { "Vorname darf nicht leer sein" }
        require(nachname.isNotBlank()) { "Nachname darf nicht leer sein" }
        val patient = patientenRepository.findById(id) ?: throw AggregateNotFoundException()

        val updatedPatient = patient.update(
            titel = titel,
            vorname = vorname,
            nachname = nachname,
            strasse = strasse,
            hausnummer = hausnummer,
            plz = plz,
            stadt = stadt,
            telMobil = telMobil,
            telFestnetz = telFestnetz,
            email = email,
            geburtstag = geburtstag,
            behandlungenProRezept = behandlungenProRezept,
        )

        return patientenRepository.save(updatedPatient)
    }
}

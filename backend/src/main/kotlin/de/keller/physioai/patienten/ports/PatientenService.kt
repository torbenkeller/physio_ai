package de.keller.physioai.patienten.ports

import de.keller.physioai.patienten.domain.PatientAggregate
import de.keller.physioai.shared.PatientId
import org.jmolecules.architecture.hexagonal.PrimaryPort
import java.time.LocalDate

@PrimaryPort
interface PatientenService {
    /**
     * Creates a new patient with the given information
     * @param titel Optional academic title of the patient
     * @param vorname First name of the patient (must not be blank)
     * @param nachname Last name of the patient (must not be blank)
     * @param strasse Optional street name of patient's address
     * @param hausnummer Optional house number of patient's address
     * @param plz Optional postal code of patient's address
     * @param stadt Optional city of patient's address
     * @param telMobil Optional mobile phone number
     * @param telFestnetz Optional landline phone number
     * @param email Optional email address
     * @param geburtstag Optional date of birth
     * @return The newly created patient
     * @throws IllegalArgumentException if vorname or nachname is blank
     */
    fun createPatient(
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
    ): PatientAggregate

    /**
     * Updates an existing patient with the given information
     * @param id The unique identifier of the patient to update
     * @param titel Optional academic title of the patient
     * @param vorname First name of the patient (must not be blank)
     * @param nachname Last name of the patient (must not be blank)
     * @param strasse Optional street name of patient's address
     * @param hausnummer Optional house number of patient's address
     * @param plz Optional postal code of patient's address
     * @param stadt Optional city of patient's address
     * @param telMobil Optional mobile phone number
     * @param telFestnetz Optional landline phone number
     * @param email Optional email address
     * @param geburtstag Optional date of birth
     * @return The updated patient
     * @throws IllegalArgumentException if vorname or nachname is blank
     */
    fun updatePatient(
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
    ): PatientAggregate
}

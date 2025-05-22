package de.keller.physioai.patienten.domain

import de.keller.physioai.patienten.Patient
import de.keller.physioai.patienten.PatientId
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDate

@ConsistentCopyVisibility
@Table("patienten")
data class PatientAggregate internal constructor(
    @Id
    override val id: PatientId,
    override val titel: String?,
    override val vorname: String,
    override val nachname: String,
    override val strasse: String?,
    override val hausnummer: String?,
    override val plz: String?,
    override val stadt: String?,
    override val telMobil: String?,
    override val telFestnetz: String?,
    override val email: String?,
    override val geburtstag: LocalDate?,
    @Version
    val version: Int = 0,
) : Patient {
    fun update(
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
    ): PatientAggregate =
        copy(
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
        )

    companion object {
        fun create(
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
        ): PatientAggregate =
            PatientAggregate(
                id = PatientId.generate(),
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
            )
    }
}

package de.keller.physioai.rezepte.domain

import de.keller.physioai.patienten.PatientId
import de.keller.physioai.rezepte.RezeptId
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.MappedCollection
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID

@Table("rezepte")
data class Rezept(
    @Id
    val id: RezeptId,
    val patientId: PatientId,
    val ausgestelltAm: LocalDate,
    val ausgestelltVonArztId: ArztId?,
    val preisGesamt: Double,
    val rechnungsnummer: String? = null,
    @MappedCollection(idColumn = "rezept_id", keyColumn = "index")
    val positionen: List<RezeptPos>,
    @MappedCollection(idColumn = "rezept_id", keyColumn = "index")
    val behandlungen: List<Behandlung> = emptyList(),
    @Version
    val version: Int = 0,
) {
    fun update(
        patientId: PatientId,
        ausgestelltAm: LocalDate,
        ausgestelltVonArztId: ArztId?,
        rechnungsnummer: String?,
        posSources: List<CreateRezeptPosData>,
    ): Rezept {
        if (posSources.isEmpty()) {
            throw IllegalArgumentException("A rezept must have at least one position")
        }

        val positionen = posSources.map(CreateRezeptPosData::toPosition)
        val preisGesamt = positionen.sumOf { it.preisGesamt }

        return copy(
            patientId = patientId,
            ausgestelltAm = ausgestelltAm,
            rechnungsnummer = rechnungsnummer,
            ausgestelltVonArztId = ausgestelltVonArztId,
            positionen = positionen,
            preisGesamt = preisGesamt,
        )
    }

    fun addBehandlung(
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
    ): Rezept {
        val newBehandlung = Behandlung.createNew(
            rezeptId = id,
            startZeit = startZeit,
            endZeit = endZeit,
        )

        // Sort behandlungen by startZeit
        val sortedBehandlungen = (behandlungen + newBehandlung).sortedBy { it.startZeit }

        return copy(
            behandlungen = sortedBehandlungen,
        )
    }

    fun removeBehandlung(behandlungId: UUID): Rezept {
        val updatedBehandlungen = behandlungen.filter { it.id != behandlungId }
        if (updatedBehandlungen.size == behandlungen.size) {
            return this // No change if not found
        }

        return copy(
            behandlungen = updatedBehandlungen,
        )
    }

    companion object {
        fun createNew(
            patientId: PatientId,
            ausgestelltAm: LocalDate,
            ausgestelltVonArztId: ArztId?,
            posSources: List<CreateRezeptPosData>,
        ): Rezept {
            if (posSources.isEmpty()) {
                throw IllegalArgumentException("A rezept must have at least one position")
            }

            val positionen = posSources.map(CreateRezeptPosData::toPosition)
            val preisGesamt = positionen.sumOf { it.preisGesamt }

            return Rezept(
                id = RezeptId.generate(),
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = ausgestelltVonArztId,
                preisGesamt = preisGesamt,
                positionen = positionen,
                behandlungen = emptyList(),
            )
        }

        data class CreateRezeptPosData(
            val behandlungsartId: BehandlungsartId,
            val behandlungsartName: String,
            val behandlungsartPreis: Double,
            val anzahl: Int,
        ) {
            fun toPosition(): RezeptPos =
                RezeptPos(
                    id = UUID.randomUUID(),
                    behandlungsartId = behandlungsartId,
                    anzahl = anzahl,
                    einzelpreis = behandlungsartPreis,
                    preisGesamt = behandlungsartPreis * anzahl,
                    behandlungsartName = behandlungsartName,
                )
        }
    }
}

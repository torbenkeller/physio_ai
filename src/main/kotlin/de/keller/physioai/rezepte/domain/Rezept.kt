package de.keller.physioai.rezepte.domain

import de.keller.physioai.patienten.PatientId
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.MappedCollection
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDate
import java.util.UUID

data class RezeptId(
    val id: UUID,
) {
    companion object {
        fun fromUUID(id: UUID): RezeptId = RezeptId(id)

        fun generate(): RezeptId = RezeptId(UUID.randomUUID())
    }
}

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
    @Version
    val version: Long = 0,
) {
    fun update(
        patientId: PatientId,
        ausgestelltAm: LocalDate,
        ausgestelltVonArztId: ArztId?,
        rechnungsnummer: String?,
        posSources: List<RezeptPosSource>,
    ): Rezept {
        val positionen = posSources.map(RezeptPosSource::toPosition)
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

    companion object {
        fun createNew(
            patientId: PatientId,
            ausgestelltAm: LocalDate,
            ausgestelltVonArztId: ArztId?,
            posSources: List<RezeptPosSource>,
        ): Rezept {
            val positionen = posSources.map(RezeptPosSource::toPosition)
            val preisGesamt = positionen.sumOf { it.preisGesamt }

            return Rezept(
                id = RezeptId.generate(),
                patientId = patientId,
                ausgestelltAm = ausgestelltAm,
                ausgestelltVonArztId = ausgestelltVonArztId,
                preisGesamt = preisGesamt,
                positionen = positionen,
            )
        }
    }
}

data class RezeptPosSource(
    val behandlungsart: Behandlungsart,
    val anzahl: Long,
) {
    fun toPosition(): RezeptPos =
        RezeptPos(
            id = UUID.randomUUID(),
            behandlungsartId = behandlungsart.id,
            anzahl = anzahl,
            einzelpreis = behandlungsart.preis,
            preisGesamt = behandlungsart.preis * anzahl,
            behandlungsartName = behandlungsart.name,
        )
}

@Table("rezept_pos")
data class RezeptPos(
    @Id
    val id: UUID,
    val behandlungsartId: BehandlungsartId,
    val anzahl: Long,
    val einzelpreis: Double,
    val preisGesamt: Double,
    val behandlungsartName: String,
)

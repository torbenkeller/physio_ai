package de.keller.physio_ai.rezepte

import de.keller.physio_ai.patienten.PatientId
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.MappedCollection
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDate
import java.util.*


data class RezeptId(val id: UUID) {
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
    val rechnungsnummer: String?,

    @MappedCollection(idColumn = "rezept_id", keyColumn = "index")
    val positionen: List<RezeptPos>,

    @Version
    val version: Long = 0
) {
}
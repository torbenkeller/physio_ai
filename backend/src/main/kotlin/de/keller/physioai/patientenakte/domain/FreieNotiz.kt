package de.keller.physioai.patientenakte.domain

import de.keller.physioai.shared.EintragId
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDateTime
import java.util.UUID

/**
 * Eine freie Notiz in der Patientenakte, nicht an einen Behandlungstermin gebunden.
 * Kann kategorisiert werden (z.B. Diagnose, Beobachtung, Sonstiges).
 *
 * Entity innerhalb des PatientenakteAggregate - wird über @MappedCollection verwaltet.
 */
@Table("akte_freie_notizen")
data class FreieNotiz(
    @Id
    val id: EintragId,
    val kategorie: NotizKategorie,
    val inhalt: String,
    val istAngepinnt: Boolean = false,
    val erstelltAm: LocalDateTime,
    val aktualisiertAm: LocalDateTime?,
) {
    fun aktualisiereInhalt(neuerInhalt: String): FreieNotiz {
        require(neuerInhalt.isNotBlank()) { "Notiz-Inhalt darf nicht leer sein" }
        return copy(
            inhalt = neuerInhalt,
            aktualisiertAm = LocalDateTime.now(),
        )
    }

    fun setzeAngepinnt(angepinnt: Boolean): FreieNotiz = copy(istAngepinnt = angepinnt)

    companion object {
        fun create(
            kategorie: NotizKategorie,
            inhalt: String,
        ): FreieNotiz {
            require(inhalt.isNotBlank()) { "Notiz-Inhalt darf nicht leer sein" }
            return FreieNotiz(
                id = EintragId(UUID.randomUUID()),
                kategorie = kategorie,
                inhalt = inhalt,
                istAngepinnt = false,
                erstelltAm = LocalDateTime.now(),
                aktualisiertAm = null,
            )
        }
    }
}

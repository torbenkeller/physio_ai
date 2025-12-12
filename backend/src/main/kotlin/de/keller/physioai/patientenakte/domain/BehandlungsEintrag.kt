package de.keller.physioai.patientenakte.domain

import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.EintragId
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDateTime
import java.util.UUID

/**
 * Ein Eintrag in der Patientenakte, der aus einer Behandlung synchronisiert wurde.
 * Enthält Referenz zur Original-Behandlung und optional eine Notiz.
 *
 * Entity innerhalb des PatientenakteAggregate - wird über @MappedCollection verwaltet.
 */
@Table("akte_behandlungs_eintraege")
data class BehandlungsEintrag(
    @Id
    val id: EintragId,
    val behandlungId: BehandlungId,
    val behandlungsDatum: LocalDateTime,
    val notizInhalt: String?,
    val notizErstelltAm: LocalDateTime?,
    val notizAktualisiertAm: LocalDateTime?,
    val istAngepinnt: Boolean = false,
    val erstelltAm: LocalDateTime,
) {
    fun aktualisiereNotiz(neuerInhalt: String): BehandlungsEintrag {
        val jetzt = LocalDateTime.now()
        return copy(
            notizInhalt = neuerInhalt,
            notizErstelltAm = notizErstelltAm ?: jetzt,
            notizAktualisiertAm = jetzt,
        )
    }

    fun aktualisiereBehandlungsDatum(neuesDatum: LocalDateTime): BehandlungsEintrag = copy(behandlungsDatum = neuesDatum)

    fun setzeAngepinnt(angepinnt: Boolean): BehandlungsEintrag = copy(istAngepinnt = angepinnt)

    companion object {
        fun create(
            behandlungId: BehandlungId,
            behandlungsDatum: LocalDateTime,
            bemerkung: String? = null,
        ): BehandlungsEintrag {
            val jetzt = LocalDateTime.now()
            return BehandlungsEintrag(
                id = EintragId(UUID.randomUUID()),
                behandlungId = behandlungId,
                behandlungsDatum = behandlungsDatum,
                notizInhalt = bemerkung,
                notizErstelltAm = if (bemerkung != null) jetzt else null,
                notizAktualisiertAm = null,
                istAngepinnt = false,
                erstelltAm = jetzt,
            )
        }
    }
}

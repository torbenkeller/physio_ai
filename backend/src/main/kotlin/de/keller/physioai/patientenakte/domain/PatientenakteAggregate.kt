package de.keller.physioai.patientenakte.domain

import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.EintragId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.PatientenakteId
import org.jmolecules.ddd.annotation.AggregateRoot
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.MappedCollection
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDateTime
import java.util.UUID

/**
 * Aggregate Root für die Patientenakte.
 * Verwaltet die Einträge (Behandlungen und freie Notizen) eines Patienten.
 * Alle Kind-Entitäten werden innerhalb der Transaktionsgrenze dieses Aggregates verwaltet.
 */
@AggregateRoot
@Table("patientenakten")
data class PatientenakteAggregate(
    @Id
    val id: PatientenakteId,
    val patientId: PatientId,
    @MappedCollection(idColumn = "patientenakte_id")
    val behandlungsEintraege: Set<BehandlungsEintrag> = emptySet(),
    @MappedCollection(idColumn = "patientenakte_id")
    val freieNotizen: Set<FreieNotiz> = emptySet(),
    @Version
    val version: Int = 0,
) {
    // --- Behandlungs-Einträge ---

    fun synchronisiereBehandlungsEintrag(
        behandlungId: BehandlungId,
        behandlungsDatum: LocalDateTime,
        bemerkung: String?,
    ): PatientenakteAggregate {
        val bestehenderEintrag = behandlungsEintraege.find { it.behandlungId == behandlungId }

        return if (bestehenderEintrag != null) {
            val aktualisierterEintrag = bestehenderEintrag
                .aktualisiereBehandlungsDatum(behandlungsDatum)
                .let { if (bemerkung != null && bemerkung != bestehenderEintrag.notizInhalt) it.aktualisiereNotiz(bemerkung) else it }

            copy(behandlungsEintraege = behandlungsEintraege - bestehenderEintrag + aktualisierterEintrag)
        } else {
            val neuerEintrag = BehandlungsEintrag.create(
                behandlungId = behandlungId,
                behandlungsDatum = behandlungsDatum,
                bemerkung = bemerkung,
            )
            copy(behandlungsEintraege = behandlungsEintraege + neuerEintrag)
        }
    }

    fun loescheBehandlungsEintrag(behandlungId: BehandlungId): PatientenakteAggregate {
        val zuLoeschen = behandlungsEintraege.find { it.behandlungId == behandlungId }
            ?: return this
        return copy(behandlungsEintraege = behandlungsEintraege - zuLoeschen)
    }

    fun aktualisiereBehandlungsNotiz(
        eintragId: EintragId,
        neuerInhalt: String,
    ): PatientenakteAggregate {
        val eintrag = behandlungsEintraege.find { it.id == eintragId }
            ?: throw IllegalArgumentException("BehandlungsEintrag nicht gefunden: $eintragId")

        val aktualisierterEintrag = eintrag.aktualisiereNotiz(neuerInhalt)
        return copy(behandlungsEintraege = behandlungsEintraege - eintrag + aktualisierterEintrag)
    }

    fun pinneBehandlungsEintrag(
        eintragId: EintragId,
        angepinnt: Boolean,
    ): PatientenakteAggregate {
        val eintrag = behandlungsEintraege.find { it.id == eintragId }
            ?: throw IllegalArgumentException("BehandlungsEintrag nicht gefunden: $eintragId")

        val aktualisierterEintrag = eintrag.setzeAngepinnt(angepinnt)
        return copy(behandlungsEintraege = behandlungsEintraege - eintrag + aktualisierterEintrag)
    }

    // --- Freie Notizen ---

    data class ErstelleFreieNotizResult(
        val aktualisierteAkte: PatientenakteAggregate,
        val erstellteNotiz: FreieNotiz,
    )

    fun erstelleFreieNotiz(
        kategorie: NotizKategorie,
        inhalt: String,
    ): ErstelleFreieNotizResult {
        val notiz = FreieNotiz.create(
            kategorie = kategorie,
            inhalt = inhalt,
        )
        return ErstelleFreieNotizResult(
            aktualisierteAkte = copy(freieNotizen = freieNotizen + notiz),
            erstellteNotiz = notiz,
        )
    }

    fun loescheFreieNotiz(eintragId: EintragId): PatientenakteAggregate {
        val zuLoeschen = freieNotizen.find { it.id == eintragId }
            ?: throw IllegalArgumentException("FreieNotiz nicht gefunden: $eintragId")
        return copy(freieNotizen = freieNotizen - zuLoeschen)
    }

    fun aktualisiereFreieNotiz(
        eintragId: EintragId,
        neuerInhalt: String,
    ): PatientenakteAggregate {
        val notiz = freieNotizen.find { it.id == eintragId }
            ?: throw IllegalArgumentException("FreieNotiz nicht gefunden: $eintragId")

        val aktualisierteNotiz = notiz.aktualisiereInhalt(neuerInhalt)
        return copy(freieNotizen = freieNotizen - notiz + aktualisierteNotiz)
    }

    fun pinneFreieNotiz(
        eintragId: EintragId,
        angepinnt: Boolean,
    ): PatientenakteAggregate {
        val notiz = freieNotizen.find { it.id == eintragId }
            ?: throw IllegalArgumentException("FreieNotiz nicht gefunden: $eintragId")

        val aktualisierteNotiz = notiz.setzeAngepinnt(angepinnt)
        return copy(freieNotizen = freieNotizen - notiz + aktualisierteNotiz)
    }

    // --- Abfragen ---

    fun findBehandlungsEintrag(eintragId: EintragId): BehandlungsEintrag? = behandlungsEintraege.find { it.id == eintragId }

    fun findFreieNotiz(eintragId: EintragId): FreieNotiz? = freieNotizen.find { it.id == eintragId }

    companion object {
        fun create(patientId: PatientId): PatientenakteAggregate =
            PatientenakteAggregate(
                id = PatientenakteId(UUID.randomUUID()),
                patientId = patientId,
            )
    }
}

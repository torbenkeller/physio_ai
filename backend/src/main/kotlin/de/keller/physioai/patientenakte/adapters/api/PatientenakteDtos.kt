package de.keller.physioai.patientenakte.adapters.api

import de.keller.physioai.patientenakte.domain.BehandlungsEintrag
import de.keller.physioai.patientenakte.domain.FreieNotiz
import de.keller.physioai.patientenakte.domain.NotizKategorie
import de.keller.physioai.patientenakte.ports.PatientenakteService
import java.time.LocalDateTime
import java.util.UUID

// Response DTOs

data class PatientenakteDto(
    val patientId: UUID,
    val eintraege: List<AktenEintragDto>,
) {
    companion object {
        fun fromDomain(dto: PatientenakteService.PatientenakteDto): PatientenakteDto {
            val behandlungsEintraege = dto.behandlungsEintraege.map { BehandlungsEintragDto.fromDomain(it) }
            val freieNotizen = dto.freieNotizen.map { FreieNotizDto.fromDomain(it) }

            // Alle Einträge kombinieren und sortieren:
            // 1. Angepinnte zuerst (nach Datum sortiert)
            // 2. Dann nicht-angepinnte nach Datum (neueste zuerst)
            val alleEintraege = (behandlungsEintraege + freieNotizen)
                .sortedWith(
                    compareByDescending<AktenEintragDto> { it.istAngepinnt }
                        .thenByDescending { it.sortierDatum },
                )

            return PatientenakteDto(
                patientId = dto.patientId.id,
                eintraege = alleEintraege,
            )
        }
    }
}

sealed interface AktenEintragDto {
    val id: UUID
    val typ: String
    val istAngepinnt: Boolean
    val erstelltAm: LocalDateTime
    val sortierDatum: LocalDateTime
}

data class BehandlungsEintragDto(
    override val id: UUID,
    override val typ: String = "BEHANDLUNG",
    val behandlungId: UUID,
    val behandlungsDatum: LocalDateTime,
    val notiz: NotizDto?,
    override val istAngepinnt: Boolean,
    override val erstelltAm: LocalDateTime,
) : AktenEintragDto {
    override val sortierDatum: LocalDateTime
        get() = behandlungsDatum

    companion object {
        fun fromDomain(eintrag: BehandlungsEintrag): BehandlungsEintragDto =
            BehandlungsEintragDto(
                id = eintrag.id.id,
                behandlungId = eintrag.behandlungId.id,
                behandlungsDatum = eintrag.behandlungsDatum,
                notiz = if (eintrag.notizInhalt != null) {
                    NotizDto(
                        inhalt = eintrag.notizInhalt,
                        erstelltAm = eintrag.notizErstelltAm!!,
                        aktualisiertAm = eintrag.notizAktualisiertAm,
                    )
                } else {
                    null
                },
                istAngepinnt = eintrag.istAngepinnt,
                erstelltAm = eintrag.erstelltAm,
            )
    }
}

data class FreieNotizDto(
    override val id: UUID,
    override val typ: String = "FREIE_NOTIZ",
    val kategorie: String,
    val inhalt: String,
    val aktualisiertAm: LocalDateTime?,
    override val istAngepinnt: Boolean,
    override val erstelltAm: LocalDateTime,
) : AktenEintragDto {
    override val sortierDatum: LocalDateTime
        get() = erstelltAm

    companion object {
        fun fromDomain(notiz: FreieNotiz): FreieNotizDto =
            FreieNotizDto(
                id = notiz.id.id,
                kategorie = notiz.kategorie.name,
                inhalt = notiz.inhalt,
                aktualisiertAm = notiz.aktualisiertAm,
                istAngepinnt = notiz.istAngepinnt,
                erstelltAm = notiz.erstelltAm,
            )
    }
}

data class NotizDto(
    val inhalt: String,
    val erstelltAm: LocalDateTime,
    val aktualisiertAm: LocalDateTime?,
)

// Request DTOs

data class FreieNotizFormDto(
    val kategorie: String,
    val inhalt: String,
) {
    fun toKategorie(): NotizKategorie = NotizKategorie.valueOf(kategorie)
}

data class NotizUpdateDto(
    val inhalt: String,
)

data class PinUpdateDto(
    val istAngepinnt: Boolean,
)

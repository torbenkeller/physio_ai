package de.keller.physioai.patientenakte.adapters.api

import de.keller.physioai.patientenakte.ports.PatientenakteService
import de.keller.physioai.shared.EintragId
import de.keller.physioai.shared.PatientId
import jakarta.validation.Valid
import org.jmolecules.architecture.hexagonal.PrimaryAdapter
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@PrimaryAdapter
@RestController
@RequestMapping("/patientenakte")
class PatientenakteController(
    private val patientenakteService: PatientenakteService,
) {
    /**
     * Gibt die gesamte Patientenakte mit allen Einträgen zurück.
     * Einträge sind sortiert: angepinnte zuerst, dann chronologisch (neueste zuerst).
     */
    @GetMapping("/{patientId}")
    fun getPatientenakte(
        @PathVariable patientId: UUID,
    ): PatientenakteDto {
        val akte = patientenakteService.getPatientenakte(PatientId(patientId))
        return PatientenakteDto.fromDomain(akte)
    }

    /**
     * Erstellt eine neue freie Notiz in der Patientenakte.
     */
    @PostMapping("/{patientId}/notizen")
    @ResponseStatus(HttpStatus.CREATED)
    fun createFreieNotiz(
        @PathVariable patientId: UUID,
        @Valid @RequestBody formDto: FreieNotizFormDto,
    ): FreieNotizDto {
        val notiz = patientenakteService.erstelleFreieNotiz(
            patientId = PatientId(patientId),
            kategorie = formDto.toKategorie(),
            inhalt = formDto.inhalt,
        )
        return FreieNotizDto.fromDomain(notiz)
    }

    /**
     * Löscht eine freie Notiz.
     */
    @DeleteMapping("/{patientId}/notizen/{eintragId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    fun deleteFreieNotiz(
        @PathVariable patientId: UUID,
        @PathVariable eintragId: UUID,
    ) {
        patientenakteService.loescheFreieNotiz(PatientId(patientId), EintragId(eintragId))
    }

    /**
     * Aktualisiert die Notiz eines Behandlungs-Eintrags.
     */
    @PatchMapping("/{patientId}/behandlungen/{eintragId}/notiz")
    fun updateBehandlungsNotiz(
        @PathVariable patientId: UUID,
        @PathVariable eintragId: UUID,
        @Valid @RequestBody dto: NotizUpdateDto,
    ): BehandlungsEintragDto {
        val eintrag = patientenakteService.aktualisiereBehandlungsNotiz(
            patientId = PatientId(patientId),
            eintragId = EintragId(eintragId),
            neuerInhalt = dto.inhalt,
        )
        return BehandlungsEintragDto.fromDomain(eintrag)
    }

    /**
     * Aktualisiert den Inhalt einer freien Notiz.
     */
    @PatchMapping("/{patientId}/notizen/{eintragId}")
    fun updateFreieNotiz(
        @PathVariable patientId: UUID,
        @PathVariable eintragId: UUID,
        @Valid @RequestBody dto: NotizUpdateDto,
    ): FreieNotizDto {
        val notiz = patientenakteService.aktualisiereFreieNotiz(
            patientId = PatientId(patientId),
            eintragId = EintragId(eintragId),
            neuerInhalt = dto.inhalt,
        )
        return FreieNotizDto.fromDomain(notiz)
    }

    /**
     * Setzt den Pin-Status eines Behandlungs-Eintrags.
     */
    @PatchMapping("/{patientId}/behandlungen/{eintragId}/pin")
    fun pinBehandlungsEintrag(
        @PathVariable patientId: UUID,
        @PathVariable eintragId: UUID,
        @Valid @RequestBody dto: PinUpdateDto,
    ): BehandlungsEintragDto {
        val eintrag = patientenakteService.pinneBehandlungsEintrag(
            patientId = PatientId(patientId),
            eintragId = EintragId(eintragId),
            angepinnt = dto.istAngepinnt,
        )
        return BehandlungsEintragDto.fromDomain(eintrag)
    }

    /**
     * Setzt den Pin-Status einer freien Notiz.
     */
    @PatchMapping("/{patientId}/notizen/{eintragId}/pin")
    fun pinFreieNotiz(
        @PathVariable patientId: UUID,
        @PathVariable eintragId: UUID,
        @Valid @RequestBody dto: PinUpdateDto,
    ): FreieNotizDto {
        val notiz = patientenakteService.pinneFreieNotiz(
            patientId = PatientId(patientId),
            eintragId = EintragId(eintragId),
            angepinnt = dto.istAngepinnt,
        )
        return FreieNotizDto.fromDomain(notiz)
    }
}

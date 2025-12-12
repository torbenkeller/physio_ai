package de.keller.physioai.patientenakte.ports

import de.keller.physioai.patientenakte.domain.BehandlungsEintrag
import de.keller.physioai.patientenakte.domain.FreieNotiz
import de.keller.physioai.patientenakte.domain.NotizKategorie
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.EintragId
import de.keller.physioai.shared.PatientId
import org.jmolecules.architecture.hexagonal.PrimaryPort
import java.time.LocalDateTime

@PrimaryPort
interface PatientenakteService {
    // Behandlungs-Einträge (synchronisiert über Events)
    fun synchronisiereBehandlungsEintrag(
        behandlungId: BehandlungId,
        patientId: PatientId,
        behandlungsDatum: LocalDateTime,
        bemerkung: String?,
    )

    fun loescheBehandlungsEintrag(
        behandlungId: BehandlungId,
        patientId: PatientId,
    )

    // Freie Notizen
    fun erstelleFreieNotiz(
        patientId: PatientId,
        kategorie: NotizKategorie,
        inhalt: String,
    ): FreieNotiz

    fun loescheFreieNotiz(
        patientId: PatientId,
        eintragId: EintragId,
    )

    // Notiz-Bearbeitung (für beide Typen)
    fun aktualisiereBehandlungsNotiz(
        patientId: PatientId,
        eintragId: EintragId,
        neuerInhalt: String,
    ): BehandlungsEintrag

    fun aktualisiereFreieNotiz(
        patientId: PatientId,
        eintragId: EintragId,
        neuerInhalt: String,
    ): FreieNotiz

    // Pinning
    fun pinneBehandlungsEintrag(
        patientId: PatientId,
        eintragId: EintragId,
        angepinnt: Boolean,
    ): BehandlungsEintrag

    fun pinneFreieNotiz(
        patientId: PatientId,
        eintragId: EintragId,
        angepinnt: Boolean,
    ): FreieNotiz

    // Abfragen
    fun getPatientenakte(patientId: PatientId): PatientenakteDto

    data class PatientenakteDto(
        val patientId: PatientId,
        val behandlungsEintraege: List<BehandlungsEintrag>,
        val freieNotizen: List<FreieNotiz>,
    )
}

package de.keller.physioai.patientenakte.application

import de.keller.physioai.patientenakte.domain.BehandlungsEintrag
import de.keller.physioai.patientenakte.domain.FreieNotiz
import de.keller.physioai.patientenakte.domain.NotizKategorie
import de.keller.physioai.patientenakte.domain.PatientenakteAggregate
import de.keller.physioai.patientenakte.ports.PatientenakteRepository
import de.keller.physioai.patientenakte.ports.PatientenakteService
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.EintragId
import de.keller.physioai.shared.PatientId
import org.jmolecules.architecture.hexagonal.Application
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Application
@Service
@Transactional
class PatientenakteServiceImpl(
    private val patientenakteRepository: PatientenakteRepository,
) : PatientenakteService {
    override fun synchronisiereBehandlungsEintrag(
        behandlungId: BehandlungId,
        patientId: PatientId,
        behandlungsDatum: LocalDateTime,
        bemerkung: String?,
    ) {
        val akte = patientenakteRepository.findByPatientId(patientId)
            ?: patientenakteRepository.save(PatientenakteAggregate.create(patientId))

        val aktualisierteAkte = akte.synchronisiereBehandlungsEintrag(
            behandlungId = behandlungId,
            behandlungsDatum = behandlungsDatum,
            bemerkung = bemerkung,
        )
        patientenakteRepository.save(aktualisierteAkte)
    }

    override fun synchronisiereBehandlungsEintraegeBatch(eintraege: List<PatientenakteService.BehandlungsEintragData>) {
        if (eintraege.isEmpty()) return

        // Gruppiere nach Patient, um alle Einträge eines Patienten sequenziell zu verarbeiten
        val eintraegeNachPatient = eintraege.groupBy { it.patientId }

        eintraegeNachPatient.forEach { (patientId, patientEintraege) ->
            // Akte holen oder erstellen
            var akte = patientenakteRepository.findByPatientId(patientId)
                ?: patientenakteRepository.save(PatientenakteAggregate.create(patientId))

            // Alle Einträge dieses Patienten sequenziell zur Akte hinzufügen
            patientEintraege.forEach { eintrag ->
                akte = akte.synchronisiereBehandlungsEintrag(
                    behandlungId = eintrag.behandlungId,
                    behandlungsDatum = eintrag.behandlungsDatum,
                    bemerkung = eintrag.bemerkung,
                )
            }

            // Einmal speichern mit allen Einträgen
            patientenakteRepository.save(akte)
        }
    }

    override fun loescheBehandlungsEintrag(
        behandlungId: BehandlungId,
        patientId: PatientId,
    ) {
        val akte = patientenakteRepository.findByPatientId(patientId) ?: return
        val aktualisierteAkte = akte.loescheBehandlungsEintrag(behandlungId)
        patientenakteRepository.save(aktualisierteAkte)
    }

    override fun erstelleFreieNotiz(
        patientId: PatientId,
        kategorie: NotizKategorie,
        inhalt: String,
    ): FreieNotiz {
        val akte = getOrCreatePatientenakte(patientId)
        val (aktualisierteAkte, erstellteNotiz) = akte.erstelleFreieNotiz(kategorie, inhalt)
        patientenakteRepository.save(aktualisierteAkte)
        return erstellteNotiz
    }

    override fun loescheFreieNotiz(
        patientId: PatientId,
        eintragId: EintragId,
    ) {
        val akte = patientenakteRepository.findByPatientId(patientId)
            ?: throw AggregateNotFoundException()
        val aktualisierteAkte = akte.loescheFreieNotiz(eintragId)
        patientenakteRepository.save(aktualisierteAkte)
    }

    override fun aktualisiereBehandlungsNotiz(
        patientId: PatientId,
        eintragId: EintragId,
        neuerInhalt: String,
    ): BehandlungsEintrag {
        val akte = patientenakteRepository.findByPatientId(patientId)
            ?: throw AggregateNotFoundException()
        val aktualisierteAkte = akte.aktualisiereBehandlungsNotiz(eintragId, neuerInhalt)
        val gespeicherteAkte = patientenakteRepository.save(aktualisierteAkte)
        return gespeicherteAkte.findBehandlungsEintrag(eintragId)
            ?: throw AggregateNotFoundException("BehandlungsEintrag nicht gefunden: $eintragId")
    }

    override fun aktualisiereFreieNotiz(
        patientId: PatientId,
        eintragId: EintragId,
        neuerInhalt: String,
    ): FreieNotiz {
        val akte = patientenakteRepository.findByPatientId(patientId)
            ?: throw AggregateNotFoundException()
        val aktualisierteAkte = akte.aktualisiereFreieNotiz(eintragId, neuerInhalt)
        val gespeicherteAkte = patientenakteRepository.save(aktualisierteAkte)
        return gespeicherteAkte.findFreieNotiz(eintragId)
            ?: throw AggregateNotFoundException("FreieNotiz nicht gefunden: $eintragId")
    }

    override fun pinneBehandlungsEintrag(
        patientId: PatientId,
        eintragId: EintragId,
        angepinnt: Boolean,
    ): BehandlungsEintrag {
        val akte = patientenakteRepository.findByPatientId(patientId)
            ?: throw AggregateNotFoundException()
        val aktualisierteAkte = akte.pinneBehandlungsEintrag(eintragId, angepinnt)
        val gespeicherteAkte = patientenakteRepository.save(aktualisierteAkte)
        return gespeicherteAkte.findBehandlungsEintrag(eintragId)
            ?: throw AggregateNotFoundException("BehandlungsEintrag nicht gefunden: $eintragId")
    }

    override fun pinneFreieNotiz(
        patientId: PatientId,
        eintragId: EintragId,
        angepinnt: Boolean,
    ): FreieNotiz {
        val akte = patientenakteRepository.findByPatientId(patientId)
            ?: throw AggregateNotFoundException()
        val aktualisierteAkte = akte.pinneFreieNotiz(eintragId, angepinnt)
        val gespeicherteAkte = patientenakteRepository.save(aktualisierteAkte)
        return gespeicherteAkte.findFreieNotiz(eintragId)
            ?: throw AggregateNotFoundException("FreieNotiz nicht gefunden: $eintragId")
    }

    @Transactional(readOnly = true)
    override fun getPatientenakte(patientId: PatientId): PatientenakteService.PatientenakteDto {
        val akte = patientenakteRepository.findByPatientId(patientId)

        return if (akte == null) {
            // Noch keine Akte vorhanden - leere Daten zurückgeben
            PatientenakteService.PatientenakteDto(
                patientId = patientId,
                behandlungsEintraege = emptyList(),
                freieNotizen = emptyList(),
            )
        } else {
            PatientenakteService.PatientenakteDto(
                patientId = patientId,
                behandlungsEintraege = akte.behandlungsEintraege.toList(),
                freieNotizen = akte.freieNotizen.toList(),
            )
        }
    }

    private fun getOrCreatePatientenakte(patientId: PatientId): PatientenakteAggregate {
        val bestehende = patientenakteRepository.findByPatientId(patientId)
        if (bestehende != null) {
            return bestehende
        }

        val neueAkte = PatientenakteAggregate.create(patientId)
        return patientenakteRepository.save(neueAkte)
    }
}

package de.keller.physioai.patientenakte.application

import de.keller.physioai.behandlungen.Behandlung
import de.keller.physioai.patientenakte.ports.PatientenakteService
import org.springframework.data.relational.core.mapping.event.AfterDeleteEvent
import org.springframework.data.relational.core.mapping.event.AfterSaveEvent
import org.springframework.modulith.events.ApplicationModuleListener
import org.springframework.stereotype.Component

/**
 * Event-Handler, der auf Spring Data JDBC Events von Behandlung lauscht
 * und die Patientenakte entsprechend synchronisiert.
 */
@Component
class BehandlungEventHandler(
    private val patientenakteService: PatientenakteService,
) {
    @ApplicationModuleListener
    fun onBehandlungGespeichert(event: AfterSaveEvent<Behandlung>) {
        val behandlung = event.entity
        patientenakteService.synchronisiereBehandlungsEintrag(
            behandlungId = behandlung.id,
            patientId = behandlung.patientId,
            behandlungsDatum = behandlung.startZeit,
            bemerkung = behandlung.bemerkung,
        )
    }

    @ApplicationModuleListener
    fun onBehandlungGeloescht(event: AfterDeleteEvent<Behandlung>) {
        val behandlung = event.entity ?: return
        patientenakteService.loescheBehandlungsEintrag(
            behandlungId = behandlung.id,
            patientId = behandlung.patientId,
        )
    }
}

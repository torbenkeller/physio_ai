package de.keller.physioai.patientenakte.application

import de.keller.physioai.behandlungen.BehandlungGeaendertEvent
import de.keller.physioai.behandlungen.BehandlungGeloeschtEvent
import de.keller.physioai.behandlungen.BehandlungenGeaendertEvent
import de.keller.physioai.patientenakte.ports.PatientenakteService
import org.springframework.modulith.events.ApplicationModuleListener
import org.springframework.stereotype.Component

/**
 * Event-Handler, der auf Domain Events aus dem Behandlungen-Modul lauscht
 * und die Patientenakte entsprechend synchronisiert.
 *
 * Verwendet @ApplicationModuleListener von Spring Modulith für garantierte
 * Event-Auslieferung und saubere Modul-Grenzen.
 */
@Component
class BehandlungEventHandler(
    private val patientenakteService: PatientenakteService,
) {
    @ApplicationModuleListener
    fun on(event: BehandlungGeaendertEvent) {
        patientenakteService.synchronisiereBehandlungsEintrag(
            behandlungId = event.behandlungId,
            patientId = event.patientId,
            behandlungsDatum = event.startZeit,
            bemerkung = event.bemerkung,
        )
    }

    @ApplicationModuleListener
    fun on(event: BehandlungenGeaendertEvent) {
        patientenakteService.synchronisiereBehandlungsEintraegeBatch(
            eintraege = event.behandlungen.map { behandlung ->
                PatientenakteService.BehandlungsEintragData(
                    behandlungId = behandlung.behandlungId,
                    patientId = behandlung.patientId,
                    behandlungsDatum = behandlung.startZeit,
                    bemerkung = behandlung.bemerkung,
                )
            },
        )
    }

    @ApplicationModuleListener
    fun on(event: BehandlungGeloeschtEvent) {
        patientenakteService.loescheBehandlungsEintrag(
            behandlungId = event.behandlungId,
            patientId = event.patientId,
        )
    }
}

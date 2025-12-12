package de.keller.physioai.patientenakte.application

import de.keller.physioai.behandlungen.BehandlungGeaendertEvent
import de.keller.physioai.behandlungen.BehandlungGeloeschtEvent
import de.keller.physioai.behandlungen.BehandlungenGeaendertEvent
import de.keller.physioai.patientenakte.ports.PatientenakteService
import org.slf4j.LoggerFactory
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
    private val logger = LoggerFactory.getLogger(BehandlungEventHandler::class.java)

    @ApplicationModuleListener
    fun on(event: BehandlungGeaendertEvent) {
        try {
            patientenakteService.synchronisiereBehandlungsEintrag(
                behandlungId = event.behandlungId,
                patientId = event.patientId,
                behandlungsDatum = event.startZeit,
                bemerkung = event.bemerkung,
            )
        } catch (e: Exception) {
            logger.error(
                "Fehler beim Synchronisieren des Behandlungs-Eintrags: behandlungId={}, patientId={}",
                event.behandlungId,
                event.patientId,
                e,
            )
            throw e
        }
    }

    @ApplicationModuleListener
    fun on(event: BehandlungenGeaendertEvent) {
        try {
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
        } catch (e: Exception) {
            logger.error(
                "Fehler beim Batch-Synchronisieren von {} Behandlungs-Einträgen",
                event.behandlungen.size,
                e,
            )
            throw e
        }
    }

    @ApplicationModuleListener
    fun on(event: BehandlungGeloeschtEvent) {
        try {
            patientenakteService.loescheBehandlungsEintrag(
                behandlungId = event.behandlungId,
                patientId = event.patientId,
            )
        } catch (e: Exception) {
            logger.error(
                "Fehler beim Löschen des Behandlungs-Eintrags: behandlungId={}, patientId={}",
                event.behandlungId,
                event.patientId,
                e,
            )
            throw e
        }
    }
}

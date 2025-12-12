package de.keller.physioai.patientenakte.application

import de.keller.physioai.behandlungen.Behandlung
import de.keller.physioai.patientenakte.ports.PatientenakteService
import org.springframework.context.event.EventListener
import org.springframework.data.relational.core.mapping.event.AfterDeleteEvent
import org.springframework.data.relational.core.mapping.event.AfterSaveEvent
import org.springframework.stereotype.Component

/**
 * Event-Handler, der auf Spring Data JDBC Events von Behandlung lauscht
 * und die Patientenakte entsprechend synchronisiert.
 *
 * Verwendet @EventListener mit manueller Typprüfung, da Spring Data JDBC Events
 * mit dem konkreten Entity-Typ gefeuert werden und AbstractRelationalEventListener
 * mit dem Interface nicht funktioniert.
 */
@Component
class BehandlungEventHandler(
    private val patientenakteService: PatientenakteService,
) {
    @EventListener
    fun onAfterSave(event: AfterSaveEvent<*>) {
        val entity = event.entity
        if (entity is Behandlung) {
            patientenakteService.synchronisiereBehandlungsEintrag(
                behandlungId = entity.id,
                patientId = entity.patientId,
                behandlungsDatum = entity.startZeit,
                bemerkung = entity.bemerkung,
            )
        }
    }

    @EventListener
    fun onAfterDelete(event: AfterDeleteEvent<*>) {
        val entity = event.entity
        if (entity is Behandlung) {
            patientenakteService.loescheBehandlungsEintrag(
                behandlungId = entity.id,
                patientId = entity.patientId,
            )
        }
    }
}

package de.keller.physioai.patientenakte.application

import de.keller.physioai.patienten.PatientErstelltEvent
import de.keller.physioai.patientenakte.domain.PatientenakteAggregate
import de.keller.physioai.patientenakte.ports.PatientenakteRepository
import org.springframework.context.event.EventListener
import org.springframework.stereotype.Component

@Component
class PatientEventHandler(
    private val patientenakteRepository: PatientenakteRepository,
) {
    @EventListener
    fun on(event: PatientErstelltEvent) {
        val neueAkte = PatientenakteAggregate.create(event.patientId)
        patientenakteRepository.save(neueAkte)
    }
}

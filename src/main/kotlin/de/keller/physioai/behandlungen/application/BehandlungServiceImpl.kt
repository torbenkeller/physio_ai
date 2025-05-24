package de.keller.physioai.behandlungen.application

import de.keller.physioai.behandlungen.domain.BehandlungAggregate
import de.keller.physioai.behandlungen.ports.BehandlungRepository
import de.keller.physioai.behandlungen.ports.BehandlungService
import de.keller.physioai.shared.AggregateNotFoundException
import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.jmolecules.architecture.hexagonal.Application
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Application
@Service
@Transactional
class BehandlungServiceImpl(
    private val behandlungRepository: BehandlungRepository,
) : BehandlungService {
    override fun createBehandlung(
        patientId: PatientId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
    ): BehandlungAggregate {
        val behandlung = BehandlungAggregate.create(
            patientId = patientId,
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
        )
        return behandlungRepository.save(behandlung)
    }

    override fun updateBehandlung(
        id: BehandlungId,
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
    ): BehandlungAggregate {
        val behandlung = behandlungRepository.findById(id)
            ?: throw AggregateNotFoundException()

        val updatedBehandlung = behandlung.update(
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
        )
        return behandlungRepository.save(updatedBehandlung)
    }

    override fun deleteBehandlung(id: BehandlungId) {
        val behandlung = behandlungRepository.findById(id)
            ?: throw AggregateNotFoundException()

        return behandlungRepository.delete(behandlung)
    }
}

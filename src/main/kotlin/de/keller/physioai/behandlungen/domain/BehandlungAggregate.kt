package de.keller.physioai.behandlungen.domain

import de.keller.physioai.shared.BehandlungId
import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.jmolecules.ddd.annotation.AggregateRoot
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDateTime
import java.util.UUID

@AggregateRoot
@Table("behandlungen")
data class BehandlungAggregate(
    @Id
    val id: BehandlungId,
    val patientId: PatientId,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val rezeptId: RezeptId?,
    @Version
    val version: Int = 0,
) {
    fun update(
        startZeit: LocalDateTime,
        endZeit: LocalDateTime,
        rezeptId: RezeptId?,
    ): BehandlungAggregate {
        require(startZeit.isBefore(endZeit)) { "Start time must be before end time" }
        return copy(
            startZeit = startZeit,
            endZeit = endZeit,
            rezeptId = rezeptId,
        )
    }

    fun verschiebe(nach: LocalDateTime): BehandlungAggregate {
        val duration = java.time.Duration.between(startZeit, endZeit)
        val neueEndZeit = nach.plus(duration)
        return copy(
            startZeit = nach,
            endZeit = neueEndZeit,
        )
    }

    companion object {
        fun create(
            patientId: PatientId,
            startZeit: LocalDateTime,
            endZeit: LocalDateTime,
            rezeptId: RezeptId?,
        ): BehandlungAggregate {
            require(startZeit.isBefore(endZeit)) { "Start time must be before end time" }
            return BehandlungAggregate(
                id = BehandlungId(UUID.randomUUID()),
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = rezeptId,
            )
        }
    }
}

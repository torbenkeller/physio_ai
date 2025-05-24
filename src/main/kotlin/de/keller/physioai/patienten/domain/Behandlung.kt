package de.keller.physioai.patienten.domain

import de.keller.physioai.shared.PatientId
import de.keller.physioai.shared.RezeptId
import org.jmolecules.ddd.annotation.Entity
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDateTime
import java.util.UUID

@Entity
@Table("behandlungen")
data class Behandlung(
    @Id
    val id: UUID,
    val patientId: PatientId,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    val rezeptId: RezeptId?,
    @Version
    val version: Int = 0,
) {
    companion object {
        fun createNew(
            patientId: PatientId,
            startZeit: LocalDateTime,
            endZeit: LocalDateTime,
            rezeptId: RezeptId?,
        ): Behandlung {
            require(startZeit.isBefore(endZeit)) { "Start time must be before end time" }
            return Behandlung(
                id = UUID.randomUUID(),
                patientId = patientId,
                startZeit = startZeit,
                endZeit = endZeit,
                rezeptId = rezeptId,
            )
        }
    }
}

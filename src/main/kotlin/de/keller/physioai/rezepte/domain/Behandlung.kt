package de.keller.physioai.rezepte.domain

import de.keller.physioai.rezepte.RezeptId
import org.jmolecules.ddd.annotation.AggregateRoot
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table
import java.time.LocalDateTime
import java.util.UUID

@AggregateRoot
@Table("behandlungen")
data class Behandlung(
    @Id
    val id: UUID,
    val rezeptId: RezeptId,
    val startZeit: LocalDateTime,
    val endZeit: LocalDateTime,
    @Version
    val version: Int = 0,
) {
    companion object {
        fun createNew(
            rezeptId: RezeptId,
            startZeit: LocalDateTime,
            endZeit: LocalDateTime,
        ): Behandlung =
            Behandlung(
                id = UUID.randomUUID(),
                rezeptId = rezeptId,
                startZeit = startZeit,
                endZeit = endZeit,
            )
    }
}

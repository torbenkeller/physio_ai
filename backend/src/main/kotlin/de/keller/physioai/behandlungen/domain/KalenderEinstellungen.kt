package de.keller.physioai.behandlungen.domain

import de.keller.physioai.shared.KalenderEinstellungenId
import org.jmolecules.ddd.annotation.AggregateRoot
import org.springframework.data.annotation.Id
import org.springframework.data.annotation.Version
import org.springframework.data.relational.core.mapping.Table
import java.util.UUID

@AggregateRoot
@Table("kalender_einstellungen")
data class KalenderEinstellungen(
    @Id
    val id: KalenderEinstellungenId,
    val externalCalendarUrl: String?,
    @Version
    val version: Int = 0,
) {
    fun updateExternalCalendarUrl(url: String?): KalenderEinstellungen = copy(externalCalendarUrl = url)

    companion object {
        fun create(externalCalendarUrl: String? = null): KalenderEinstellungen =
            KalenderEinstellungen(
                id = KalenderEinstellungenId(UUID.randomUUID()),
                externalCalendarUrl = externalCalendarUrl,
            )
    }
}

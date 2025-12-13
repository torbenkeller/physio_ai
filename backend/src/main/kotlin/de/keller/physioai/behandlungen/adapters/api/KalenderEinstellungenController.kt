package de.keller.physioai.behandlungen.adapters.api

import de.keller.physioai.behandlungen.ports.KalenderAnsichtService
import org.jmolecules.architecture.hexagonal.PrimaryAdapter
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@PrimaryAdapter
@RestController
@RequestMapping("/behandlungen/kalender/einstellungen")
class KalenderEinstellungenController(
    private val kalenderAnsichtService: KalenderAnsichtService,
) {
    @GetMapping
    fun getKalenderEinstellungen(): KalenderEinstellungenDto {
        val einstellungen = kalenderAnsichtService.getKalenderEinstellungen()
        return KalenderEinstellungenDto(
            externalCalendarUrl = einstellungen.externalCalendarUrl,
        )
    }

    @PutMapping
    fun updateKalenderEinstellungen(
        @RequestBody dto: KalenderEinstellungenDto,
    ): KalenderEinstellungenDto {
        val updated = kalenderAnsichtService.updateExternalCalendarUrl(dto.externalCalendarUrl)
        return KalenderEinstellungenDto(
            externalCalendarUrl = updated.externalCalendarUrl,
        )
    }
}

data class KalenderEinstellungenDto(
    val externalCalendarUrl: String?,
)

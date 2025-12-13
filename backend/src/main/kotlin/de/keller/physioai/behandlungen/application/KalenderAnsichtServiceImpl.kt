package de.keller.physioai.behandlungen.application

import de.keller.physioai.behandlungen.domain.KalenderEinstellungen
import de.keller.physioai.behandlungen.ports.BehandlungenService
import de.keller.physioai.behandlungen.ports.ExternerKalenderPort
import de.keller.physioai.behandlungen.ports.KalenderAnsichtService
import de.keller.physioai.behandlungen.ports.KalenderAnsichtService.BehandlungTermin
import de.keller.physioai.behandlungen.ports.KalenderAnsichtService.ExternerTerminResponse
import de.keller.physioai.behandlungen.ports.KalenderAnsichtService.WochenkalenderResponse
import de.keller.physioai.behandlungen.ports.KalenderEinstellungenRepository
import org.jmolecules.architecture.hexagonal.Application
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.time.LocalDate

@Application
@Service
class KalenderAnsichtServiceImpl(
    private val behandlungenService: BehandlungenService,
    private val externerKalenderPort: ExternerKalenderPort,
    private val kalenderEinstellungenRepository: KalenderEinstellungenRepository,
) : KalenderAnsichtService {
    private val logger = LoggerFactory.getLogger(KalenderAnsichtServiceImpl::class.java)

    override fun getWochenkalender(datum: LocalDate): WochenkalenderResponse {
        // Calculate week start (Monday) and end (Sunday)
        val weekStart = datum.minusDays(datum.dayOfWeek.value.toLong() - 1)
        val weekEnd = weekStart.plusDays(6)

        // 1. Get internal treatments
        val weeklyCalendar = behandlungenService.getWeeklyCalendar(datum)
        val behandlungen = weeklyCalendar.mapValues { (_, list) ->
            list.map { response ->
                BehandlungTermin(
                    id = response.behandlungAggregate.id.id,
                    patientId = response.patient.id.id,
                    patientVorname = response.patient.vorname,
                    patientNachname = response.patient.nachname,
                    patientGeburtstag = response.patient.geburtstag,
                    startZeit = response.behandlungAggregate.startZeit,
                    endZeit = response.behandlungAggregate.endZeit,
                    rezeptId = response.behandlungAggregate.rezeptId?.id,
                    behandlungsartId = response.behandlungAggregate.behandlungsartId?.id,
                    bemerkung = response.behandlungAggregate.bemerkung,
                )
            }
        }

        // 2. Get external events via secondary port
        val kalenderEinstellungen = getOrCreateKalenderEinstellungen()
        val calendarUrl = kalenderEinstellungen.externalCalendarUrl

        val externeTermine = if (!calendarUrl.isNullOrBlank()) {
            try {
                externerKalenderPort
                    .getExterneTermine(calendarUrl, weekStart, weekEnd)
                    .map { termin ->
                        ExternerTerminResponse(
                            uid = termin.uid,
                            title = termin.title,
                            startZeit = termin.startZeit,
                            endZeit = termin.endZeit,
                            isAllDay = termin.isAllDay,
                        )
                    }
            } catch (e: Exception) {
                logger.warn("Failed to fetch external calendar events: ${e.message}")
                emptyList()
            }
        } else {
            emptyList()
        }

        return WochenkalenderResponse(
            behandlungen = behandlungen,
            externeTermine = externeTermine,
        )
    }

    override fun getKalenderEinstellungen(): KalenderEinstellungen = getOrCreateKalenderEinstellungen()

    override fun updateExternalCalendarUrl(url: String?): KalenderEinstellungen {
        val existing = getOrCreateKalenderEinstellungen()
        // Load via findById to ensure proper entity tracking
        val reloaded = kalenderEinstellungenRepository.findById(existing.id)
            ?: throw IllegalStateException("KalenderEinstellungen not found after creation")
        val updated = reloaded.updateExternalCalendarUrl(url)
        return kalenderEinstellungenRepository.save(updated)
    }

    private fun getOrCreateKalenderEinstellungen(): KalenderEinstellungen {
        val existing = kalenderEinstellungenRepository.findFirst()
        if (existing != null) {
            return existing
        }

        // Create default settings if none exist
        val newSettings = KalenderEinstellungen.create()
        return kalenderEinstellungenRepository.save(newSettings)
    }
}

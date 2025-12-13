package de.keller.physioai.behandlungen.ports

import de.keller.physioai.behandlungen.domain.KalenderEinstellungen
import de.keller.physioai.shared.KalenderEinstellungenId
import org.jmolecules.architecture.hexagonal.SecondaryPort

@SecondaryPort
interface KalenderEinstellungenRepository {
    fun save(kalenderEinstellungen: KalenderEinstellungen): KalenderEinstellungen

    fun findById(id: KalenderEinstellungenId): KalenderEinstellungen?

    fun findFirst(): KalenderEinstellungen?
}

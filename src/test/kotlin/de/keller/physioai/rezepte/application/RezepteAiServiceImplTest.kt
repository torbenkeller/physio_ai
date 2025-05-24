package de.keller.physioai.rezepte.application

import de.keller.physioai.patienten.Patient
import de.keller.physioai.patienten.PatientenRepository
import de.keller.physioai.rezepte.domain.Behandlungsart
import de.keller.physioai.rezepte.domain.BehandlungsartId
import de.keller.physioai.rezepte.ports.BehandlungsartenRepository
import de.keller.physioai.rezepte.ports.RezepteAiService
import de.keller.physioai.shared.PatientId
import io.mockk.impl.annotations.MockK
import java.time.LocalDate

class RezepteAiServiceImplTest {
    @MockK
    private lateinit var rezepteAiService: RezepteAiService

    @MockK
    private lateinit var patientenRepository: PatientenRepository

    @MockK
    private lateinit var behandlungsartenRepository: BehandlungsartenRepository

    private val patientId = PatientId.Companion.generate()
    private val behandlungsartId1 = BehandlungsartId.Companion.generate()
    private val behandlungsartId2 = BehandlungsartId.Companion.generate()
    private val ausgestelltAm = LocalDate.of(2023, 1, 1)

    private lateinit var patient: Patient
    private lateinit var behandlungsart1: Behandlungsart
    private lateinit var behandlungsart2: Behandlungsart
}

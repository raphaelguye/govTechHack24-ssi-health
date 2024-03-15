package ch.govtech.govtech24issuermock.service

import ch.govtech.govtech24issuermock.model.*
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.time.ZonedDateTime
import java.util.UUID

@Service
class ProofRequestService(
    @Value("\${present-endpoint-base-url}") var url: String,
    val proofRepository: ProofRepository,
    val medicationRepository: MedicationRepository,
) {
    fun createNewProofRequest(): ProofRequestContent {
        val prId = UUID.randomUUID().toString()
        var prc = ProofRequestContent(
            ZonedDateTime.now().minusMonths(2),
            ZonedDateTime.now().minusDays(1),
            "Medication",
            url + "/api/present/medication/" + prId
        )
        val pr = ProofRequest(prId, prc, mutableListOf())
        return proofRepository.save(pr).content;
    }

    fun submitResponse(id: String, medications: List<Medication>): ProofRequestContent {
        var pr = proofRepository.findById(id).get()
        medications.forEach {
            medicationRepository.save(it)
        }
        pr.responses.addAll(medications)
        return proofRepository.save(pr).content
    }
}
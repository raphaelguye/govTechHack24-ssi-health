package ch.govtech.govtech24issuermock

import ch.govtech.govtech24issuermock.model.Medication
import ch.govtech.govtech24issuermock.model.ProofRequestContent
import ch.govtech.govtech24issuermock.service.ProofRequestService
import org.springframework.web.bind.annotation.*
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/present/medication")
class RestController(val proofRequestService: ProofRequestService) {

    init {
        println("test")
    }
    @GetMapping("/create-pr")
    fun createProofRequest(): ProofRequestContent {
        return proofRequestService.createNewProofRequest()
    }
    @PostMapping("/{id}")
    fun presentMedicationVc(@PathVariable id: String, @RequestBody medications: List<Medication>) {
        proofRequestService.submitResponse(id, medications)
    }
}
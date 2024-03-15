package ch.govtech.govtech24issuermock

import ch.govtech.govtech24issuermock.model.Medication
import ch.govtech.govtech24issuermock.service.MockDataService
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping


@Controller
@RequestMapping("/pharmacy")
class PharmacyController(val mockDataService: MockDataService) {
    @GetMapping("/medications")
    fun showMedications(model: Model): Any {
        // Assuming you have a method to fetch JSON data and parse it into a List<Medication>
        val medications = fetchMedicationsFromJson()
        model.addAttribute("medications", medications)
        model.addAttribute("person", mockDataService.getInsuranceCard())
        return "medication"
    }
    // Method to fetch JSON data and parse it into a List<Medication>
    private fun fetchMedicationsFromJson(): List<Medication> {
        return mockDataService.getAllCredentials().filter { it.type == "Medication" }.map { it as Medication }.toList()
    }
}


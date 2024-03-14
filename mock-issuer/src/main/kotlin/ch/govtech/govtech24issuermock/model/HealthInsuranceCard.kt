package ch.govtech.govtech24issuermock.model

import java.util.*


data class HealthInsuranceCard(
    val cardNumber: String,
    val holderName: String,
    val dateOfBirth: Date,
    val gender: Gender,
    val insuranceCompany: String
    ) {
        enum class Gender {
            Male, Female, Other
        }
}
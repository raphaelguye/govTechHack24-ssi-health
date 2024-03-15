package ch.govtech.govtech24issuermock.model

import jakarta.persistence.Embedded
import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.ManyToOne
import jakarta.persistence.OneToMany
import java.time.ZonedDateTime
import java.util.UUID

data class ProofRequestContent(
    var issuedFrom: ZonedDateTime?,
    val issuedTo: ZonedDateTime?,
    val type: String?,
    val presentationUrl: String
) {

    constructor() : this(null, null, null, "")
}

@Entity
data class ProofRequest(
    @Id var id: String,
    @Embedded var content: ProofRequestContent,
    @OneToMany var responses: MutableList<Medication>
) {
    constructor() : this(
        UUID.randomUUID().toString(),
        ProofRequestContent(null, null, null, ""),
        mutableListOf()
    ) {

    }
}


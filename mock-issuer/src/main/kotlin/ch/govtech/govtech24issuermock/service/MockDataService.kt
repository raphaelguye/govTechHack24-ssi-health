package ch.govtech.govtech24issuermock.service

import ch.govtech.govtech24issuermock.model.Credential
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import org.springframework.core.io.ClassPathResource
import org.springframework.stereotype.Service
import java.time.*
import java.time.temporal.ChronoUnit
import java.util.UUID
import kotlin.random.Random

@Service
class MockDataService {

    companion object {
        val mapper: ObjectMapper = jacksonObjectMapper().registerModule(JavaTimeModule())
        val healthRecords: List<Credential> = mapper.readValue(ClassPathResource("mock.json").inputStream)

    }
    fun getAllCredentials(): List<Credential> {
        for (r in healthRecords) {
            var start: ZonedDateTime = ZonedDateTime.of(LocalDate.ofYearDay(2020, 1), LocalTime.MIDNIGHT, ZoneId.of("UTC"))
            var end: ZonedDateTime = ZonedDateTime.now();
            r.issueDate = getRandomDateTime(start, end)
            r.id = UUID.randomUUID().toString()
        }
        return healthRecords;

    }

    fun getRandomDateTime(start: ZonedDateTime, end: ZonedDateTime): ZonedDateTime {
        val random = Random.Default

        val startEpochDay = start.toLocalDate().toEpochDay()
        val endEpochDay = end.toLocalDate().toEpochDay()
        val randomDay = startEpochDay + random.nextInt((endEpochDay - startEpochDay).toInt())

        var randomNanoOfDay = random.nextLong() % ChronoUnit.DAYS.duration.toNanos()
        if (randomNanoOfDay < 0) {
            randomNanoOfDay += ChronoUnit.DAYS.duration.toNanos()
        }

        var localDateTime = LocalDateTime.ofEpochSecond(
            randomDay * 24 * 60 * 60 + randomNanoOfDay / 1_000_000_000,0, ZoneOffset.UTC)
        return ZonedDateTime.of(localDateTime, ZoneId.of("UTC"))
    }

    fun getCredentialOfType() {

    }
}


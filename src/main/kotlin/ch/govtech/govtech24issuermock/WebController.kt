package ch.govtech.govtech24issuermock

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("api/v1/test")
class WebController() {
    init {
        println("test")
    }


    @GetMapping
    fun test(): String {
        return "Hello World"
    }
}
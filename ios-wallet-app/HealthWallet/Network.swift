import Foundation
import Papyrus

// MARK: - Issuer

@API
@Authorization(.basic(username: "primary", password: "yI0LPJwOF5HqwHC3LnICdX5b6sqXIw2RppFNkWa2l1NuiAfAVMb9IeH6iPIC5o3F"))
@Headers([
  "Content-Type": "application/json",
])
protocol Issuer {

  @JSON(decoder: .iso8601)
  @GET("/medical")
  func getCredentials() async throws -> [Credential]

  @JSON(decoder: .standard)
  @GET("/insurance")
  func getInsurance() async throws -> InsuranceCredential

}

// MARK: - Verifier

@API
@Headers([
  "Content-Type": "application/json",
])
protocol Verifier {

  @JSON(decoder: .iso8601)
  @POST("/present")
  func sendCredentials() async throws -> [Credential]

}

extension JSONDecoder {
  static var iso8601: JSONDecoder {
    let encoder = JSONDecoder()
    encoder.dateDecodingStrategy = .iso8601
    return encoder
  }

  static var standard: JSONDecoder {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-mm-dd"

    let encoder = JSONDecoder()
    encoder.dateDecodingStrategy = .formatted(dateFormatter)
    return encoder
  }
}

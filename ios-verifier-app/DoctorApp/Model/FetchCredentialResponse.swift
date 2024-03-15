import Foundation

// MARK: - FetchCredentialResponse

struct FetchCredentialResponse: Codable {
  let data: [Presentation]
}

// MARK: - Presentation

struct Presentation: Codable {
  let id: Int
  let dateCreated: String
  let credential: [Credential]

  enum CodingKeys: String, CodingKey {
    case id
    case dateCreated = "date_created"
    case credential = "vc"
  }
}

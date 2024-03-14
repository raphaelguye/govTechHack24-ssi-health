import Foundation

class ContentViewModel: ObservableObject {

  // MARK: Lifecycle

  init() {
    verifiableCredentials = loadVerifiableCredentials()
    verifableCredentialsByMonth = loadVerifiableCredentialsGroupedByMonth()
  }

  // MARK: Internal

  @Published var verifiableCredentials: [Credential] = []
  @Published var verifableCredentialsByMonth: [String: [Credential]] = [:]

  func loadVerifiableCredentials() -> [Credential] {
    guard let url = Bundle.main.url(forResource: "verifiableCredentials", withExtension: "json") else {
      print("VerifiableCredentials JSON file not found")
      return []
    }

    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let credentials = try decoder.decode([Credential].self, from: data)
      return credentials.sorted { $0.issuedAt < $1.issuedAt }
    } catch {
      print("Error decoding VerifiableCredentials JSON: \(error)")
      return []
    }
  }

  func loadVerifiableCredentialsGroupedByMonth() -> [String: [Credential]] {
    guard let url = Bundle.main.url(forResource: "verifiableCredentials", withExtension: "json") else {
      print("VerifiableCredentials JSON file not found")
      return [:]
    }

    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let credentials = try decoder.decode([Credential].self, from: data)

      // Group by month and year
      let groupedCredentials = Dictionary(grouping: credentials) { credential -> String in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: credential.issuedAt)
      }

      // Optional: Sort each group by issuedAt, if needed
      let sortedGroupedCredentials = groupedCredentials.mapValues { credentials in
        credentials.sorted { $0.issuedAt < $1.issuedAt }
      }

      return sortedGroupedCredentials
    } catch {
      print("Error decoding VerifiableCredentials JSON: \(error)")
      return [:]
    }
  }

}

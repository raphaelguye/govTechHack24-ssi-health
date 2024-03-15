import Foundation
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {

  // MARK: Lifecycle

  init() {
//    Task {
//      try await refresh()
//    }
  }

  init(verifableCredentialsByMonth: [String: [Credential]]) {
    self.verifableCredentialsByMonth = verifableCredentialsByMonth
  }

  // MARK: Internal

  @Published var verifableCredentialsByMonth: [String: [Credential]] = [:]

  func refresh() async throws {
    guard let token = try await getAuthenticationToken() else {
      verifableCredentialsByMonth = [:]
      return
    }
    let foo = try await getVerifiableCredentials(token: token)
    verifableCredentialsByMonth = foo
//    verifableCredentialsByMonth = loadVerifiableCredentials()

  }

  // MARK: Private

  private func loadVerifiableCredentials() -> [String: [Credential]] {
    guard let url = Bundle.main.url(forResource: "verifiableCredentials", withExtension: "json") else {
      print("VerifiableCredentials JSON file not found")
      return [:]
    }

    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let credentials = try decoder.decode([Credential].self, from: data)
      return groupByMonth(credentials)
    } catch {
      print("Error decoding VerifiableCredentials JSON: \(error)")
      return [:]
    }
  }

  private func getAuthenticationToken() async throws -> String? {
    let urlString = "https://directustesting.proudcoast-33470e41.switzerlandnorth.azurecontainerapps.io/auth/login"
    guard let url = URL(string: urlString) else {
      return nil
    }
    let username = "admin@admin.com"
    let password = "d1r3ctu5"

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let payload: [String: String] = ["email": username, "password": password]
    guard let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
      return nil
    }
    request.httpBody = httpBody

    let (data, response) = try await URLSession.shared.data(for: request)
    guard
      let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200 else
    {
      return nil
    }

    guard
      let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
      let dataObject = jsonObject["data"] as? [String: Any],
      let accessToken = dataObject["access_token"] as? String else
    {
      return nil
    }

    return accessToken

  }

  private func getVerifiableCredentials(token: String) async throws -> [String: [Credential]] {
    let urlString = "https://directustesting.proudcoast-33470e41.switzerlandnorth.azurecontainerapps.io/items/vcs"
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let (data, _) = try await URLSession.shared.data(for: request)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    do {
      let fetchCredentialResponse = try decoder.decode(FetchCredentialResponse.self, from: data)
      let credentials = fetchCredentialResponse.data.last?.credential ?? []
      return groupByMonth(credentials)
    } catch {
      print(error)
      return [:]
    }
  }

  private func groupByMonth(_ credentials: [Credential]) -> [String: [Credential]] {
    let groupedCredentials = Dictionary(grouping: credentials) { credential -> String in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM"
      return formatter.string(from: credential.issuedAt)
    }
    let sortedGroupedCredentials = groupedCredentials.mapValues { credentials in
      credentials.sorted { $0.issuedAt < $1.issuedAt }
    }
    return sortedGroupedCredentials
  }

}

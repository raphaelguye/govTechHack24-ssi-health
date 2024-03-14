import Foundation
import SwiftData

@MainActor
final class Seeds {

  static let previewContainer: ModelContainer = {
    do {
      let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try ModelContainer(for: Credential.self, configurations: configuration)

      for i in 1...50 {
        let entry = CredentialType.allowedCases[Int.random(in: 0..<CredentialType.allowedCases.count)]
        let credential = Credential(type: entry, issuedAt: .randomBetween(start: .parse("2020-01-01"), end: .now))
        container.mainContext.insert(credential)
      }

      return container
    } catch {
      fatalError("FATAL ERROR.")
    }
  }()

}

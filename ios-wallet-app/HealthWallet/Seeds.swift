import Foundation
import SwiftData

@MainActor
final class Seeds {

  static let previewContainer: ModelContainer = {
    do {
      let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try ModelContainer(for: Credential.self, configurations: configuration)

      for i in 1...50 {
        let credential = Credential(name: "Test", type: .allergy)
        container.mainContext.insert(credential)
      }

      return container
    } catch {
      fatalError("FATAL ERROR.")
    }
  }()

}

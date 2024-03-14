import SwiftData
import SwiftUI

// MARK: - WalletView

struct WalletView: View {

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        Group {
          VStack {
            ViewThatFits {
              CredentialCard(credential: .init(type: .insurance))
                .padding()
            }
          }
        }

        VStack {
          HStack {
            Picker("Filter", selection: $selectedCategory) {
              ForEach(CredentialType.searchableCases, id: \.self) {
                Text($0.displayName)
              }
            }
            .pickerStyle(.segmented)
          }

          CredentialListView(predicate: selectedCategory == .all ? nil : #Predicate {
            $0.type == selectedCategory.rawValue
          })
        }
        .padding()
        .padding(.bottom, 72)
      }
      .refreshable {
        await refresh()
      }

      Button(action: {

      }, label: {
        Image(systemName: "qrcode")
          .font(.largeTitle)
          .foregroundColor(.white)
      })
      .padding()
      .background(Color.accentColor)
      .clipShape(.circle)
    }
    .navigationTitle("HealthWallet")
    .navigationBarTitleDisplayMode(.large)
  }

  // MARK: Private

  @State private var selectedCategory: CredentialType = .all

  @Environment(\.modelContext) private var modelContext

  private func refresh() async {
    try? await Task.sleep(for: .seconds(1))
  }

}

// MARK: - CredentialListView

struct CredentialListView: View {

  // MARK: Lifecycle

  init(predicate: Predicate<Credential>? = nil, sortBy: [SortDescriptor<Credential>] = [SortDescriptor(\.issuedAt, order: .reverse)]) {
    _credentials = Query(
      FetchDescriptor<Credential>(
        predicate: predicate,
        sortBy: [SortDescriptor(\.issuedAt, order: .reverse)]),
      animation: .smooth)
  }

  // MARK: Internal

  @Query var credentials: [Credential]

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(credentials) { credential in
        CredentialCard(credential: credential)
      }
    }
  }

}

#Preview {
  ContentView()
    .modelContainer(Seeds.previewContainer)
}

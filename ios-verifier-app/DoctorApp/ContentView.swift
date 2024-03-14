import SwiftUI

// MARK: - ContentView

struct ContentView: View {

  // MARK: Internal

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .top) {
        ForEach(viewModel.verifableCredentialsByMonth.keys.sorted(), id: \.self) { keys in

          VStack(alignment: .leading) {
            Text(keys).font(.headline)
            ForEach(viewModel.verifableCredentialsByMonth[keys] ?? [], id: \.id) { credential in
              VcView(verifiableCredential: credential)
                .frame(width: 200, height: 100)
            }
          }
          .padding(.vertical)
        }
      }
      .padding()
    }
    .navigationTitle("Credentials by Month")
  }

  // MARK: Private

  private var viewModel = ContentViewModel()

}

// MARK: - VcView

struct VcView: View {

  init(verifiableCredential: Credential) {
    self.verifiableCredential = verifiableCredential
  }

  private let verifiableCredential: Credential

  var body: some View {
    ZStack {
      Rectangle()
        .fill(verifiableCredential.type.backgroundColor)
      Text(verifiableCredential.type.displayName)
    }
  }
}

// MARK: - SeparatorView

struct SeparatorView: View {
  var body: some View {
    Rectangle()
      .frame(width: 1, height: 300)
      .foregroundColor(.gray)
      .padding(.top, 10)
  }
}

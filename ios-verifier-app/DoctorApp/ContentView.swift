import SwiftUI

// MARK: - ContentView

struct ContentView: View {

  // MARK: Lifecycle

  init() {
    dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy MMMM"
  }

  // MARK: Internal

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .top) {
        ForEach(viewModel.verifableCredentialsByMonth.keys.sorted(), id: \.self) { key in

          VStack(alignment: .leading) {
            Text(key.convertDateForHeader()).font(.headline)
            ForEach(viewModel.verifableCredentialsByMonth[key] ?? [], id: \.id) { credential in
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

  private let dateFormatter: DateFormatter

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

extension String {

  func convertDateForHeader() -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM"

    if let date = inputFormatter.date(from: self) {
      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = "yyyy MMMM"

      let formattedDateString = outputFormatter.string(from: date)
      return formattedDateString
    } else {
      return "Invalid date"
    }
  }
}

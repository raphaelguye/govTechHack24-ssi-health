import SwiftUI

// MARK: - ContentView

struct ContentView: View {

  // MARK: Internal

  var body: some View {
    content()
      .ignoresSafeArea(.container, edges: .bottom)
  }

  // MARK: Private

  @StateObject private var viewModel = ContentViewModel()
  @State private var selectedCredential: Credential?

  @ViewBuilder
  private func content() -> some View {
    VStack {
      HeaderView().padding(EdgeInsets(.init(top: 70, leading: 70, bottom: 0, trailing: 0)))
      patientHistoryView().padding(.top, 50)
      Spacer()
    }
    .sheet(item: $selectedCredential) { credential in
      CredentialDetailView(credential: credential)
    }
    .padding(0)
  }

  @ViewBuilder
  private func patientHistoryView() -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
      VStack {
        HStack(alignment: .top, spacing: 20) {
          ForEach(viewModel.verifableCredentialsByMonth.keys.sorted(), id: \.self) { key in

            VStack(alignment: .leading, spacing: 0) {
              Text(key.convertDateForHeader())
                .font(.headline)
                .padding(.bottom, 20)
                .padding(.leading, 20)
              ScrollView {
                VStack(spacing: 20) {
                  ForEach(viewModel.verifableCredentialsByMonth[key] ?? [], id: \.id) { credential in
                    CredentialCard(credential: credential)
                      .padding(.leading, 20)
                      .onTapGesture {
                        selectedCredential = credential
                      }
                  }
                }
              }
            }
          }
        }
      }.padding(.horizontal, 50)
    }
  }

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

#Preview {
  ContentView()

}

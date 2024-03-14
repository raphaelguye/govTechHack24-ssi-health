import SwiftData
import SwiftUI

// MARK: - ContentView

struct ContentView: View {

  // MARK: Internal

  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        ScrollView {
          Group {
            VStack {
              ViewThatFits {
                CredentialCard(credential: .init(name: "SWICA Insurance", type: .insurance))
                  .padding()
              }
            }
          }

          VStack {
            HStack {
              Picker("Filter", selection: $selectedCategory) {
                ForEach(CredentialType.allCases.filter({ $0 != .insurance }), id: \.self) {
                  Text($0.displayName)
                }
              }
              .onChange(of: selectedCategory, { oldValue, newValue in

              })
              .pickerStyle(.segmented)
            }

            CredentialListView(sort: [.init(\.issuedAt, order: .reverse)])
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
  }

  // MARK: Private

  @State private var selectedCategory: CredentialType = .diagnosis

  @Environment(\.modelContext) private var modelContext

  private func refresh() async {
    await query()
  }

  private func query() async {
    try? await Task.sleep(for: .seconds(1))
  }

}

// MARK: - CredentialListView

struct CredentialListView: View {

  @Query private var credentials: [Credential]

  init(filter: Predicate<Credential>? = nil, sort: [SortDescriptor<Credential>]) {
    _credentials = Query(filter: filter, sort: sort, animation: .interpolatingSpring)
  }

  var body: some View {
    VStack(alignment: .leading) {
      ForEach(credentials) { credential in
        CredentialCard(credential: credential)
      }
    }
  }

}

// MARK: - CredentialCard

struct CredentialCard: View {

  // MARK: Lifecycle

  init(credential: Credential) {
    self.credential = credential
  }

  // MARK: Public

  public enum Defaults {

    static let characterSpacing: CGFloat = -0.5

    static let imageSize: CGFloat = 28
    static let cornerRadius: CGFloat = 6
    static let shadowColor: Color = .black.opacity(0.25)
    static let shadowRadius: CGFloat = 8
    static let shadowX: CGFloat = 0
    static let shadowY: CGFloat = 4

    static let gradientMaskStartPoint: UnitPoint = .top
    static let gradientMaskEndPoint: UnitPoint = .bottom

  }

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        HStack {
          credential.type.image
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(credential.type.backgroundColor)
          Text(credential.type.displayName)
            .font(.headline)
            .lineLimit(1)

          Spacer()
          Image(systemName: "shield.lefthalf.filled.badge.checkmark")
            .renderingMode(.original)
            .foregroundColor(.primary)
        }
        .padding()

        Divider()
          .padding(.leading)
          .padding(.top, -8)

        Spacer()
      }

      VStack(alignment: .leading) {
        VStack(alignment: .leading, spacing: -3) {
          Text("Metoprolol")
            .font(.caption)
            .bold()
          Text("50mg zweimal täglich")
            .font(.caption2)
        }

        Spacer()
        HStack {
          Spacer()
          VStack(alignment: .trailing) {
            Text(credential.issuedAt.formatted(date: .numeric, time: .shortened))
          }
          .font(.caption2)
        }
        .font(.subheadline)
      }
      .padding(.top, 55)
      .padding()
    }
    .foregroundColor(.primary)
    .frame(maxWidth: .infinity, minHeight: 150)
    .background(Color(uiColor: .tertiarySystemGroupedBackground))
    .clipShape(.rect(cornerSize: .init(width: 10, height: 10), style: .continuous))
  }

  // MARK: Private

  private var credential: Credential

}

#Preview {
  ContentView()
    .modelContainer(Seeds.previewContainer)
}

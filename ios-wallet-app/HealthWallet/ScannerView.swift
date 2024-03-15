import Foundation
import QRScanner
import SwiftUI

struct ScannerView: View {

  // MARK: Internal

  var body: some View {
    ZStack(alignment: .center) {
      QRScannerView(metadataUrl: $url, isTorchAvailable: .constant(false), isTorchEnabled: .constant(false), qrScannerError: $error)

      Color.clear
        .frame(width: 64, height: 64)
        .background(.ultraThinMaterial)
        .mask(RoundedRectangle(cornerRadius: 16))
        .overlay {
          ProgressView()
            .padding()
        }
        .opacity(isLoading ? 1.0 : 0)
    }
    .navigationTitle("Scan")
    .onChange(of: url) {
      guard let url else { return }

      isLoading = true
      if url.lastPathComponent.contains("medical") {
        fetchCredentials()
      } else if url.lastPathComponent.contains("insurance") {
        fetchInsurance()
      }
    }
  }

  // MARK: Private

  @State private var url: URL?
  @State private var error: Error?
  @State private var isLoading = false

  @Environment(\.modelContext) private var modelContext

  private func fetchCredentials() {
    defer {
      isLoading = false
    }

    Task {
      let api = IssuerAPI(provider: .init(baseURL: Config.issuerBaseURL))
      do {
        let credentials = try await api.getCredentials()
        for credential in credentials {
          modelContext.insert(credential)
        }
      } catch {
      }
    }
  }

  private func fetchInsurance() {
    defer {
      isLoading = false
    }

    Task {
      let api = IssuerAPI(provider: .init(baseURL: Config.issuerBaseURL))
      do {
        let insurance = try await api.getInsurance()
        modelContext.insert(insurance)
      } catch {
        print("Issue.")
      }
    }
  }

}

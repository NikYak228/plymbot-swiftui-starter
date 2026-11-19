import SwiftUI

struct SettingsView: View {
    @State private var providerName = "My provider"

    var body: some View {
        NavigationStack {
            Form {
                Section("Workspace") {
                    TextField("Connection name", text: $providerName)
                    LabeledContent("Mode", value: "Local preview")
                }
                Section("Bring your own key") {
                    Label("API connections are coming next", systemImage: "key.horizontal")
                    Text("The initial public version demonstrates the interface. It does not collect API keys or make network requests.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Section("About") {
                    LabeledContent("App", value: "Plymbot by Plyrum")
                    LabeledContent("Version", value: "0.1 · UI starter")
                    LabeledContent("Storage", value: "In memory only")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

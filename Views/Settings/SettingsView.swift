import SwiftUI

struct SettingsView: View {
    @State private var apiKey = ""
    @State private var notificationsEnabled = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("AI Configuration")) {
                    SecureField("Replicate API Key", text: $apiKey)
                    Text("Enter your API key to enable real generation.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Section(header: Text("Preferences")) {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0").foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings ⚙️")
        }
    }
}

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var store: StoreManager
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 48))
                        VStack(alignment: .leading) {
                            Text("FaceFlow member").font(.headline)
                            Text("Your preferences stay on this device in the MVP.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Preferences") {
                    Picker("Routine length", selection: $appState.preferredDuration) {
                        ForEach([3, 5, 8, 12], id: \.self) { minutes in
                            Text("\(minutes) min").tag(minutes)
                        }
                    }
                    .onChange(of: appState.preferredDuration) { _, _ in appState.savePreferences() }

                    Picker("Preferred time", selection: $appState.preferredTime) {
                        ForEach(PreferredTime.allCases) { time in
                            Text(time.title).tag(time)
                        }
                    }
                    .onChange(of: appState.preferredTime) { _, _ in
                        appState.savePreferences()
                        if appState.notificationsEnabled {
                            Task { await NotificationManager.shared.scheduleDailyReminder(at: appState.preferredTime.dateComponents) }
                        }
                    }

                    Toggle("Daily reminder", isOn: Binding(
                        get: { appState.notificationsEnabled },
                        set: { newValue in Task { await appState.setNotifications(newValue) } }
                    ))
                }

                Section("Subscription") {
                    HStack {
                        Text("FaceFlow Pro")
                        Spacer()
                        Text(store.isPro ? "Active" : "Free")
                            .foregroundStyle(.secondary)
                    }

                    if !store.isPro {
                        Button("See Pro") { showPaywall = true }
                    }

                    Button("Restore Purchases") {
                        Task { await store.restorePurchases() }
                    }
                }

                Section("About") {
                    NavigationLink("Privacy") {
                        LegalTextView(title: "Privacy", text: privacyText)
                    }
                    NavigationLink("Terms") {
                        LegalTextView(title: "Terms", text: termsText)
                    }
                    Button("Reset onboarding") {
                        appState.resetOnboarding()
                    }
                }

                Section {
                    Text("FaceFlow is a self-care app. It does not provide medical diagnosis or treatment. Stop an exercise if it causes pain or discomfort.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Me")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .alert("StoreKit", isPresented: Binding(
                get: { store.errorMessage != nil },
                set: { if !$0 { store.errorMessage = nil } }
            )) {
                Button("OK") { store.errorMessage = nil }
            } message: {
                Text(store.errorMessage ?? "")
            }
        }
    }
}

private struct LegalTextView: View {
    let title: String
    let text: String
    var body: some View {
        ScrollView {
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
        }
        .navigationTitle(title)
    }
}

private let privacyText = """
FaceFlow MVP stores preferences and completed-session history locally on your device. The MVP does not use the camera or transmit facial/health information. If future versions add camera-based form guidance, permissions and data handling will be disclosed separately before use.
"""

private let termsText = """
FaceFlow provides general self-care and guided exercise content. It is not medical advice, diagnosis, or treatment. Use only movements that are comfortable for you and stop if you experience pain, dizziness, or other concerning symptoms. Subscription terms shown at purchase are controlled by Apple and the App Store.
"""

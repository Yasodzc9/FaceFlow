import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        if appState.hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)
            ExploreView()
                .tabItem { Label("Explore", systemImage: "sparkles") }
                .tag(1)
            ProgressViewScreen()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
                .tag(2)
            ProfileView()
                .tabItem { Label("Me", systemImage: "person.fill") }
                .tag(3)
        }
        .tint(.primary)
    }
}

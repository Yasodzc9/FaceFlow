import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showRoutine = false

    private var routine: Routine {
        RoutineGenerator.generate(
            goals: appState.selectedGoals,
            duration: appState.preferredDuration,
            experience: appState.experience
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(greeting)
                                .font(.title3)
                                .foregroundStyle(.secondary)
                            Text("Your ritual")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                        }
                        Spacer()
                    }

                    SoftCard {
                        VStack(alignment: .leading, spacing: 18) {
                            HStack {
                                Text("\(routine.durationMinutes) MINUTES")
                                    .font(.caption.weight(.bold))
                                    .tracking(1.4)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Image(systemName: "sparkles")
                            }
                            Text(routine.name)
                                .font(.title2.bold())
                            Text(routine.description)
                                .foregroundStyle(.secondary)
                            PrimaryButton(title: "Start", systemImage: "play.fill") {
                                showRoutine = true
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        StatCard(value: "\(appState.currentStreak)", label: "day streak", icon: "flame.fill")
                        StatCard(value: "\(appState.totalMinutes)", label: "minutes", icon: "clock.fill")
                    }

                    Text("Today's focus")
                        .font(.title3.bold())

                    ForEach(routine.exercises.prefix(5)) { item in
                        HStack(spacing: 14) {
                            Image(systemName: item.exercise.icon)
                                .frame(width: 38, height: 38)
                                .background(Color.faceFlowCard)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(item.exercise.name).font(.headline)
                                Text("\(item.duration) sec • \(item.exercise.difficulty)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }

                    Text("FaceFlow is a self-care app and does not provide medical diagnosis or treatment.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 10)
                }
                .padding(20)
            }
            .background(Color.faceFlowBackground)
            .navigationTitle("")
            .fullScreenCover(isPresented: $showRoutine) {
                RoutinePlayerView(routine: routine)
            }
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning" }
        if hour < 18 { return "Good afternoon" }
        return "Good evening"
    }
}

private struct StatCard: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        SoftCard {
            HStack {
                Image(systemName: icon)
                VStack(alignment: .leading) {
                    Text(value).font(.title2.bold())
                    Text(label).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }
}

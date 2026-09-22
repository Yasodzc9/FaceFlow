import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var appState: AppState
    @State private var search = ""
    @State private var selectedGoal: Goal?

    private var filtered: [Exercise] {
        ExerciseLibrary.all.filter { exercise in
            let goalMatch = selectedGoal == nil || exercise.category == selectedGoal
            let searchMatch = search.isEmpty ||
                exercise.name.localizedCaseInsensitiveContains(search) ||
                exercise.tags.contains { $0.localizedCaseInsensitiveContains(search) }
            return goalMatch && searchMatch
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Focus", selection: $selectedGoal) {
                        Text("All").tag(Optional<Goal>.none)
                        ForEach(Goal.allCases) { goal in
                            Text(goal.title).tag(Optional(goal))
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Exercises") {
                    ForEach(filtered) { exercise in
                        HStack(spacing: 14) {
                            Image(systemName: exercise.icon)
                                .frame(width: 42, height: 42)
                                .background(Color.faceFlowCard)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 3) {
                                Text(exercise.name).font(.headline)
                                Text("\(exercise.defaultDuration) sec • \(exercise.difficulty)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .searchable(text: $search, prompt: "Search exercises")
            .navigationTitle("Explore")
        }
    }
}

import SwiftUI

struct RoutinePlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    let routine: Routine

    @State private var exerciseIndex = 0
    @State private var remaining: Int
    @State private var isPaused = false
    @State private var startedAt = Date()
    @State private var completed = false

    init(routine: Routine) {
        self.routine = routine
        _remaining = State(initialValue: routine.exercises.first?.duration ?? 1)
    }

    private var current: RoutineExercise {
        routine.exercises[min(exerciseIndex, routine.exercises.count - 1)]
    }

    private var progress: Double {
        let completedSeconds = routine.exercises.prefix(exerciseIndex).reduce(0) { $0 + $1.duration }
        let currentElapsed = current.duration - remaining
        let total = max(1, routine.exercises.reduce(0) { $0 + $1.duration })
        return min(1, Double(completedSeconds + currentElapsed) / Double(total))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Button("Close") { dismiss() }
                    Spacer()
                    Text("\(exerciseIndex + 1) / \(routine.exercises.count)")
                        .font(.subheadline.weight(.semibold))
                }
                .padding()

                ProgressView(value: progress)
                    .tint(.primary)
                    .padding(.horizontal)

                Spacer()

                VStack(spacing: 28) {
                    Text(current.exercise.name.uppercased())
                        .font(.caption.weight(.bold))
                        .tracking(1.6)
                        .foregroundStyle(.secondary)

                    ZStack {
                        Circle()
                            .stroke(Color.secondary.opacity(0.15), lineWidth: 12)
                        Circle()
                            .trim(from: 0, to: CGFloat(max(0, min(1, Double(remaining) / Double(max(1, current.duration)))))
                            .stroke(.primary, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 4) {
                            Image(systemName: current.exercise.icon)
                                .font(.system(size: 42, weight: .light))
                            Text(timeString(remaining))
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .monospacedDigit()
                        }
                    }
                    .frame(width: 220, height: 220)

                    Text(current.exercise.instructions)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)

                    HStack(spacing: 12) {
                        Button {
                            if exerciseIndex > 0 {
                                exerciseIndex -= 1
                                remaining = current.duration
                                speakCurrent()
                            }
                        } label: {
                            Image(systemName: "backward.fill")
                        }
                        .buttonStyle(.bordered)

                        Button {
                            isPaused.toggle()
                            if isPaused {
                                SpeechManager.shared.stop()
                            } else {
                                speakCurrent()
                            }
                        } label: {
                            Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                .frame(width: 26, height: 26)
                        }
                        .buttonStyle(.borderedProminent)

                        Button {
                            advance()
                        } label: {
                            Image(systemName: "forward.fill")
                        }
                        .buttonStyle(.bordered)
                    }
                    .font(.title3)
                }

                Spacer()

                HStack {
                    Button("Skip") { advance() }
                    Spacer()
                    Text("Voice guidance")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(24)
            }
            .navigationBarHidden(true)
            .task {
                speakCurrent()
                await runTimer()
            }
            .alert("Ritual complete", isPresented: $completed) {
                Button("Done") { dismiss() }
            } message: {
                Text("Nice work. Your progress has been saved.")
            }
        }
    }

    private func runTimer() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .seconds(1))
            if Task.isCancelled { return }
            if isPaused { continue }

            if remaining > 1 {
                remaining -= 1
            } else {
                advance()
                if exerciseIndex >= routine.exercises.count - 1 && remaining == 0 {
                    return
                }
            }
        }
    }

    private func advance() {
        if exerciseIndex + 1 < routine.exercises.count {
            exerciseIndex += 1
            remaining = current.duration
            speakCurrent()
        } else {
            let elapsed = max(1, Int(Date().timeIntervalSince(startedAt)))
            appState.addSession(routine: routine, durationSeconds: elapsed)
            remaining = 0
            completed = true
            SpeechManager.shared.speak("Ritual complete. Nice work.")
        }
    }

    private func speakCurrent() {
        SpeechManager.shared.speak(current.exercise.voiceScript.first ?? current.exercise.instructions)
    }

    private func timeString(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

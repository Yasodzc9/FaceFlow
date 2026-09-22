import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var step = 0

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: Double(step + 1), total: 5)
                .tint(.primary)
                .padding(.horizontal, 24)
                .padding(.top, 16)

            TabView(selection: $step) {
                WelcomeStep(onContinue: next).tag(0)
                GoalsStep(onContinue: next).tag(1)
                DurationStep(onContinue: next).tag(2)
                ExperienceStep(onContinue: next).tag(3)
                ReminderStep(onFinish: finish).tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    private func next() {
        withAnimation { step += 1 }
    }

    private func finish() {
        appState.completeOnboarding()
    }
}

private struct WelcomeStep: View {
    let onContinue: () -> Void
    var body: some View {
        OnboardingContainer(
            eyebrow: "FACEFLOW",
            title: "Your 4-minute daily ritual.",
            subtitle: "Simple guided face & neck self-care routines designed to fit into your day."
        ) {
            Image(systemName: "face.smiling")
                .font(.system(size: 76, weight: .light))
                .padding(.bottom, 28)
            PrimaryButton(title: "Get Started", systemImage: "arrow.right", action: onContinue)
        }
    }
}

private struct GoalsStep: View {
    @EnvironmentObject private var appState: AppState
    let onContinue: () -> Void
    var body: some View {
        OnboardingContainer(
            eyebrow: "YOUR GOALS",
            title: "What brings you here?",
            subtitle: "Pick as many as you like."
        ) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Goal.allCases) { goal in
                    SelectionCard(
                        title: goal.title,
                        icon: goal.icon,
                        selected: appState.selectedGoals.contains(goal)
                    ) {
                        if appState.selectedGoals.contains(goal) {
                            appState.selectedGoals.remove(goal)
                        } else {
                            appState.selectedGoals.insert(goal)
                        }
                    }
                }
            }
            PrimaryButton(title: "Continue", action: onContinue)
                .padding(.top, 10)
        }
    }
}

private struct DurationStep: View {
    @EnvironmentObject private var appState: AppState
    let onContinue: () -> Void
    let options = [3, 5, 8, 12]

    var body: some View {
        OnboardingContainer(
            eyebrow: "YOUR TIME",
            title: "How much time do you have?",
            subtitle: "You can change this later."
        ) {
            ForEach(options, id: \.self) { minutes in
                SelectionRow(
                    title: "\(minutes) min",
                    subtitle: minutes == 5 ? "Balanced" : minutes == 3 ? "Quick ritual" : minutes == 8 ? "Full routine" : "Long session",
                    selected: appState.preferredDuration == minutes
                ) {
                    appState.preferredDuration = minutes
                }
            }
            PrimaryButton(title: "Continue", action: onContinue)
        }
    }
}

private struct ExperienceStep: View {
    @EnvironmentObject private var appState: AppState
    let onContinue: () -> Void

    var body: some View {
        OnboardingContainer(
            eyebrow: "YOUR EXPERIENCE",
            title: "Have you tried facial exercises before?",
            subtitle: "We'll keep your first routines simple."
        ) {
            ForEach(Experience.allCases) { experience in
                SelectionRow(title: experience.title, subtitle: nil, selected: appState.experience == experience) {
                    appState.experience = experience
                }
            }
            PrimaryButton(title: "Continue", action: onContinue)
        }
    }
}

private struct ReminderStep: View {
    @EnvironmentObject private var appState: AppState
    let onFinish: () -> Void

    var body: some View {
        OnboardingContainer(
            eyebrow: "ONE LAST THING",
            title: "Want a gentle reminder?",
            subtitle: "We'll only remind you at the time you choose."
        ) {
            ForEach(PreferredTime.allCases) { time in
                SelectionRow(title: time.title, subtitle: nil, selected: appState.preferredTime == time) {
                    appState.preferredTime = time
                }
            }
            Toggle("Daily reminder", isOn: Binding(
                get: { appState.notificationsEnabled },
                set: { newValue in
                    Task { await appState.setNotifications(newValue) }
                }
            ))
            .padding(.vertical, 8)

            PrimaryButton(title: "Start My First Ritual", systemImage: "play.fill", action: onFinish)
        }
    }
}

private struct OnboardingContainer<Content: View>: View {
    let eyebrow: String
    let title: String
    let subtitle: String
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Spacer(minLength: 30)
                Text(eyebrow)
                    .font(.caption.weight(.bold))
                    .tracking(2)
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                content
                Spacer(minLength: 20)
            }
            .padding(24)
        }
    }
}

private struct SelectionCard: View {
    let title: String
    let icon: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
            .padding(16)
            .background(selected ? Color.primary.opacity(0.12) : Color.faceFlowCard)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(selected ? Color.primary : .clear, lineWidth: 1.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
    }
}

private struct SelectionRow: View {
    let title: String
    let subtitle: String?
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title).font(.headline)
                    if let subtitle {
                        Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
            }
            .padding(18)
            .background(Color.faceFlowCard)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
    }
}

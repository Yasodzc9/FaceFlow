import Foundation
import UserNotifications

@MainActor
final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool
    @Published var selectedGoals: Set<Goal>
    @Published var preferredDuration: Int
    @Published var experience: Experience
    @Published var preferredTime: PreferredTime
    @Published var notificationsEnabled: Bool
    @Published private(set) var completedSessions: [SessionRecord]

    private let defaults = UserDefaults.standard
    private let onboardingKey = "faceflow.onboarding"
    private let goalsKey = "faceflow.goals"
    private let durationKey = "faceflow.duration"
    private let experienceKey = "faceflow.experience"
    private let timeKey = "faceflow.time"
    private let notificationsKey = "faceflow.notifications"
    private let sessionsKey = "faceflow.sessions"

    init() {
        hasCompletedOnboarding = defaults.bool(forKey: onboardingKey)
        selectedGoals = Set((defaults.stringArray(forKey: goalsKey) ?? []).compactMap(Goal.init(rawValue:)))
        preferredDuration = defaults.object(forKey: durationKey) as? Int ?? 5
        experience = Experience(rawValue: defaults.string(forKey: experienceKey) ?? "") ?? .beginner
        preferredTime = PreferredTime(rawValue: defaults.string(forKey: timeKey) ?? "") ?? .morning
        notificationsEnabled = defaults.bool(forKey: notificationsKey)

        if let data = defaults.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([SessionRecord].self, from: data) {
            completedSessions = decoded
        } else {
            completedSessions = []
        }
    }

    var todaySessions: [SessionRecord] {
        completedSessions.filter { Calendar.current.isDateInToday($0.completedAt) }
    }

    var totalMinutes: Int {
        completedSessions.reduce(0) { $0 + Int(round(Double($1.durationSeconds) / 60.0)) }
    }

    var currentStreak: Int {
        var streak = 0
        var date = Calendar.current.startOfDay(for: Date())
        if !todaySessions.isEmpty {
            streak += 1
        } else {
            guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date) else { return 0 }
            date = yesterday
        }

        while true {
            let hasSession = completedSessions.contains {
                Calendar.current.isDate($0.completedAt, inSameDayAs: date)
            }
            if !hasSession { break }
            streak += 1
            guard let previous = Calendar.current.date(byAdding: .day, value: -1, to: date) else { break }
            date = previous
        }
        return streak
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        persist()
        if notificationsEnabled {
            Task { await NotificationManager.shared.scheduleDailyReminder(at: preferredTime.dateComponents) }
        }
    }

    func resetOnboarding() {
        hasCompletedOnboarding = false
        persist()
    }

    func savePreferences() {
        persist()
    }

    func addSession(routine: Routine, durationSeconds: Int) {
        let record = SessionRecord(
            id: UUID(),
            routineID: routine.id,
            routineName: routine.name,
            completedAt: Date(),
            durationSeconds: durationSeconds
        )
        completedSessions.insert(record, at: 0)
        persist()
    }

    func setNotifications(_ enabled: Bool) async {
        notificationsEnabled = enabled
        if enabled {
            let granted = await NotificationManager.shared.requestAuthorization()
            if granted {
                await NotificationManager.shared.scheduleDailyReminder(at: preferredTime.dateComponents)
            } else {
                notificationsEnabled = false
            }
        } else {
            NotificationManager.shared.cancelReminder()
        }
        persist()
    }

    private func persist() {
        defaults.set(hasCompletedOnboarding, forKey: onboardingKey)
        defaults.set(selectedGoals.map(\.rawValue), forKey: goalsKey)
        defaults.set(preferredDuration, forKey: durationKey)
        defaults.set(experience.rawValue, forKey: experienceKey)
        defaults.set(preferredTime.rawValue, forKey: timeKey)
        defaults.set(notificationsEnabled, forKey: notificationsKey)
        if let data = try? JSONEncoder().encode(completedSessions) {
            defaults.set(data, forKey: sessionsKey)
        }
        objectWillChange.send()
    }
}

enum Goal: String, CaseIterable, Codable, Identifiable {
    case relaxation, jaw, neck, forehead, eyes, fullFace, habit

    var id: String { rawValue }

    var title: String {
        switch self {
        case .relaxation: "Relaxation"
        case .jaw: "Jaw & lower face"
        case .neck: "Neck"
        case .forehead: "Forehead"
        case .eyes: "Eye area"
        case .fullFace: "Full-face routine"
        case .habit: "Daily habit"
        }
    }

    var icon: String {
        switch self {
        case .relaxation: "wind"
        case .jaw: "person.crop.circle"
        case .neck: "figure.stand"
        case .forehead: "face.smiling"
        case .eyes: "eye"
        case .fullFace: "face.smiling.inverse"
        case .habit: "calendar"
        }
    }
}

enum Experience: String, CaseIterable, Codable, Identifiable {
    case beginner, some, experienced
    var id: String { rawValue }
    var title: String {
        switch self {
        case .beginner: "New to it"
        case .some: "I've tried a few"
        case .experienced: "I have a routine already"
        }
    }
}

enum PreferredTime: String, CaseIterable, Codable, Identifiable {
    case morning, afternoon, evening, whenever
    var id: String { rawValue }
    var title: String {
        switch self {
        case .morning: "Morning"
        case .afternoon: "Afternoon"
        case .evening: "Evening"
        case .whenever: "Whenever I remember"
        }
    }

    var dateComponents: DateComponents {
        switch self {
        case .morning: DateComponents(hour: 8, minute: 0)
        case .afternoon: DateComponents(hour: 14, minute: 0)
        case .evening: DateComponents(hour: 20, minute: 0)
        case .whenever: DateComponents(hour: 18, minute: 0)
        }
    }
}

struct SessionRecord: Codable, Identifiable {
    let id: UUID
    let routineID: UUID
    let routineName: String
    let completedAt: Date
    let durationSeconds: Int
}

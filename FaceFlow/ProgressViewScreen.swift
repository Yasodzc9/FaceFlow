import SwiftUI

struct ProgressViewScreen: View {
    @EnvironmentObject private var appState: AppState

    private var daysThisMonth: [Date] {
        let calendar = Calendar.current
        let now = Date()
        let range = calendar.range(of: .day, in: .month, for: now) ?? 1...1
        let comps = calendar.dateComponents([.year, .month], from: now)
        return range.compactMap { day in
            var c = comps
            c.day = day
            return calendar.date(from: c)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your progress")
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    HStack(spacing: 12) {
                        ProgressStat(value: "\(appState.currentStreak)", label: "day streak")
                        ProgressStat(value: "\(appState.totalMinutes)", label: "minutes")
                        ProgressStat(value: "\(appState.completedSessions.count)", label: "rituals")
                    }

                    SoftCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("This month").font(.title3.bold())
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                                ForEach(daysThisMonth, id: \.self) { date in
                                    VStack(spacing: 5) {
                                        Text(dayNumber(date))
                                            .font(.caption)
                                        Circle()
                                            .fill(hasSession(on: date) ? Color.primary : Color.secondary.opacity(0.15))
                                            .frame(width: 10, height: 10)
                                    }
                                }
                            }
                        }
                    }

                    Text("Recent rituals").font(.title3.bold())
                    if appState.completedSessions.isEmpty {
                        Text("Complete your first ritual and your history will appear here.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(appState.completedSessions.prefix(10)) { session in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                VStack(alignment: .leading) {
                                    Text(session.routineName).font(.headline)
                                    Text(session.completedAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text("\(max(1, session.durationSeconds / 60)) min")
                                    .font(.caption.weight(.semibold))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.faceFlowBackground)
            .navigationTitle("")
        }
    }

    private func hasSession(on date: Date) -> Bool {
        appState.completedSessions.contains { Calendar.current.isDate($0.completedAt, inSameDayAs: date) }
    }

    private func dayNumber(_ date: Date) -> String {
        String(Calendar.current.component(.day, from: date))
    }
}

private struct ProgressStat: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 5) {
            Text(value).font(.title2.bold())
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.faceFlowCard)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

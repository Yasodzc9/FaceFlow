import SwiftUI

extension Color {
    static let faceFlowBackground = Color(uiColor: .systemGroupedBackground)
    static let faceFlowCard = Color(uiColor: .secondarySystemGroupedBackground)
}

struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.primary)
            .foregroundStyle(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

struct SoftCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(18)
            .background(Color.faceFlowCard)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

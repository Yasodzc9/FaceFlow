import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: StoreManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 48, weight: .light))
                        .padding(.top, 20)

                    Text("Go further with FaceFlow Pro")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)

                    Text("More routines, personalization and future coaching tools.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 14) {
                        FeatureRow(text: "Complete exercise library")
                        FeatureRow(text: "Personalized routines")
                        FeatureRow(text: "Unlimited routine generation")
                        FeatureRow(text: "Advanced progress")
                        FeatureRow(text: "Future Form Coach")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if store.products.isEmpty {
                        Text("Subscription products are not configured in this build yet.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    ForEach(store.products) { product in
                        Button {
                            Task { await store.purchase(product) }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(product.displayName).font(.headline)
                                    Text(product.description).font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(product.displayPrice).fontWeight(.bold)
                            }
                            .padding(18)
                            .background(Color.faceFlowCard)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.primary)
                    }

                    Button("Restore Purchases") {
                        Task { await store.restorePurchases() }
                    }
                    .font(.subheadline.weight(.semibold))

                    Text("Subscription duration, price, trial terms and renewal details are shown by Apple at purchase.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Continue with Free") {
                        dismiss()
                    }
                    .foregroundStyle(.secondary)
                }
                .padding(24)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

private struct FeatureRow: View {
    let text: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
            Text(text)
        }
    }
}

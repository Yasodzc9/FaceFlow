import Foundation
import StoreKit

@MainActor
final class StoreManager: ObservableObject {
    static let monthlyID = "faceflow_pro_monthly"
    static let yearlyID = "faceflow_pro_yearly"

    @Published private(set) var products: [Product] = []
    @Published private(set) var isPro = false
    @Published private(set) var purchaseInProgress = false
    @Published var errorMessage: String?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task {
            for await result in Transaction.updates {
                await self.handle(result)
            }
        }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: [Self.monthlyID, Self.yearlyID])
                .sorted { $0.price < $1.price }
        } catch {
            errorMessage = "Products are unavailable until they are configured in App Store Connect."
        }
    }

    func purchase(_ product: Product) async {
        purchaseInProgress = true
        defer { purchaseInProgress = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(verification)
            case .userCancelled:
                break
            case .pending:
                errorMessage = "Your purchase is pending approval."
            @unknown default:
                break
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refreshEntitlements() async {
        var entitled = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               [Self.monthlyID, Self.yearlyID].contains(transaction.productID),
               transaction.revocationDate == nil {
                entitled = true
            }
        }
        isPro = entitled
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result else { return }
        if [Self.monthlyID, Self.yearlyID].contains(transaction.productID) {
            isPro = transaction.revocationDate == nil
        }
        await transaction.finish()
    }
}

import Foundation
import RxSwift
import RxCocoa

class BottomSheetViewModel {
    let loadingState = BehaviorRelay<LoadingState>(value: .loading)
    let paymentItem = BehaviorRelay<PaymentMethod?>(value: nil)

    func loadData() {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .getPayment)
        { [weak self] (result: Result<PaymentMethod, Error>) in
            switch result {
            case .success(let data):
                self?.loadingState.accept(.finished)
                self?.paymentItem.accept(data)
            case .failure(let error):
                self?.loadingState.accept(.failure)
                print("Error fetching payment data:", error.localizedDescription)
                if let urlError = error as? URLError {
                    print("URL Error Code:", urlError.code.rawValue)
                }
            }
        }
    }
}

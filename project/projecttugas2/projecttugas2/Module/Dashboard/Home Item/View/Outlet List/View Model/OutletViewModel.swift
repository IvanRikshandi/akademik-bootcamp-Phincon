import Foundation
import MapKit
import RxSwift
import RxCocoa

class CoffeeOutletViewModel {
    let loadingState = BehaviorRelay<LoadingState>(value: .loading)
    
    let coffeeOutlet = BehaviorRelay<Outlet?>(value: nil)
    
    func loadData() {
        APIManager.shared.fetchRequest(endpoint: .getOutlet ) { [weak self] (result: Result<Outlet, Error>) in
            guard let self = self else {return}
            
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.coffeeOutlet.accept(data)
            case .failure(_):
                self.loadingState.accept(.failure)
            }
        }
    }
}


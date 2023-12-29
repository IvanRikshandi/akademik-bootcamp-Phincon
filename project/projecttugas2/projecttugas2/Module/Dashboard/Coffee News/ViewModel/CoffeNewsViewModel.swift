import Foundation
import RxSwift
import RxCocoa

class CoffeeNewsViewModel {
    
    let loadingState = BehaviorRelay<LoadingState>(value: .loading)
    let newsArticle = BehaviorRelay<NewsCoffeeModel?>(value: nil)
    
    func fetchNews() {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .fetchNewsCoffee) { [weak self] (result: Result<NewsCoffeeModel, Error>) in
            switch result {
            case .success(let data):
                self?.loadingState.accept(.finished)
                self?.newsArticle.accept(data)
            case .failure(_):
                self?.loadingState.accept(.failure)
            }
        }
    }
}

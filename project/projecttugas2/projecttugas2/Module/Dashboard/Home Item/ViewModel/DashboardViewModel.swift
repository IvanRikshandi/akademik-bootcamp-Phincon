import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel {
    let loadingState = BehaviorRelay<LoadingState>(value: .loading)
    let name = BehaviorRelay<String?>(value: nil)
    
    var coffeeModelElement: CoffeeModel = []
    var filteredCoffees: [CoffeeModelElement] = []
    
    var onDataLoaded: (() -> Void)?
    
    func loadData() {
        APIManager.shared.fetchRequest(endpoint: .fetchCoffee) { [weak self] (result: Result<CoffeeModel, Error>) in
            guard let self = self else {return}
            
            switch result {
            case .success(let data):
                self.loadingState.accept(.finished)
                self.coffeeModelElement = data
                self.filteredCoffees = data
                self.onDataLoaded?()
            case .failure(_):
                self.loadingState.accept(.failure)
            }
        }
    }
    
    func filterByGrindOptions(selectedGrindOptions: [String]) {
        if selectedGrindOptions.isEmpty {
            filteredCoffees = coffeeModelElement
        } else {
            filteredCoffees = []
            //Membuat filteredCoffees yang hanya berisi data dengan grind options yang dipilih
            for grindOption in selectedGrindOptions {
                let filter = coffeeModelElement.filter { coffee in
                    if let grindOptions = coffee.grindOption {
                        // Menggunakan contains() untuk memeriksa apakah grindOption ada di dalam grindOptions
                        if grindOptions.contains(where: { $0.lowercased() == grindOption.lowercased() }) {
                            return true
                        }
                    }
                    return false
                }
                filteredCoffees.append(contentsOf: filter)
            }
        }
        onDataLoaded?()
    }
    
    func filterByPrice(minPrice: Double, maxPrice: Double) {
        filteredCoffees = coffeeModelElement.filter { coffee in
            if let price = coffee.price {
                return price >= minPrice && price <= maxPrice
            }
            return false
        }
        onDataLoaded?()
    }
    
    func fetchUserData(userID: String) {
        self.loadingState.accept(.loading)
        Firebase.fetchUserData(userID: userID) { result in
            switch result {
            case .success(let document):
                if document.exists {
                    let data = document.data()
                    if let name = data?["nickName"] as? String {
                        self.name.accept(name)
                        self.loadingState.accept(.finished)
                    }
                } else {
                    self.loadingState.accept(.failure)
                }
            case .failure(_):
                self.loadingState.accept(.failure)
            }
        }
    }
}

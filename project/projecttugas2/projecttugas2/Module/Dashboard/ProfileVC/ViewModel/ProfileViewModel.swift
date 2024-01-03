import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel {
    
    let loadingState = BehaviorRelay<LoadingState>(value: .loading)
    let name = BehaviorRelay<String?>(value: nil)
    let phoneNumber = BehaviorRelay<String?>(value: nil)
    let purchaseHistory = BehaviorRelay<[HistoryModel]>(value: [])
    
    func fetchHistory(userID: String) {
        loadingState.accept(.loading)
        Firebase.getSubCollectionHistory(uid: userID) { (historyItems, error) in
            if let error = error {
                self.loadingState.accept(.failure)
                print("Error fetching history: \(error.localizedDescription)")
            } else {
                self.loadingState.accept(.finished)
                print("success fetch data")
                let sortedHistory = historyItems?.sorted(by: {$0.waktu?.compare($1.waktu ?? Date()) == .orderedDescending}) ?? []
                self.purchaseHistory.accept(sortedHistory)
            }
        }
    }
    
    func fetchUserData(userID: String) {
        self.loadingState.accept(.loading)
        Firebase.fetchUserData(userID: userID) { result in
            switch result {
            case .success(let document):
                if document.exists {
                    self.loadingState.accept(.finished)
                    let data = document.data()
                    if let name = data?["fullName"] as? String,
                       let phoneNumber = data?["phoneNumber"] as? String {
                        self.name.accept(name)
                        self.phoneNumber.accept(phoneNumber)
                    }
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                self.loadingState.accept(.failure)
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    
}

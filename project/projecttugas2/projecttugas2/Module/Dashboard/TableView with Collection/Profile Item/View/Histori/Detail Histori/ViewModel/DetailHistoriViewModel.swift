//import Foundation
//import RxSwift
//import RxCocoa
//
//class DetailHistoriViewModel {
//    private let bag = DisposeBag()
//    private let historyData = BehaviorSubject<[HistoryModel]>(value: [])
//    let filteredData = BehaviorRelay<[HistoryModel]>(value: [])
//    
//    init() {
//        setupBindings()
//    }
//    
//    func updateData(_ newData: [HistoryModel]) {
//        historyData.onNext(newData)
//    }
//    
//    func filterData(with searchText: String) {
//        let filtered  = filteredData.accept(filtered)
//    }
//    
//    
//}

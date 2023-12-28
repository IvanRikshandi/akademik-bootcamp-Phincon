import Foundation
import RxSwift
import RxCocoa

class AppModeViewModel {
    let darkModeEnabled = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()
    
    func observerDarkModeChanges() {
        if let storedDarkMode = BaseConstant.userDefaults.value(forKey: "darkModeEnabled") as? Bool {
            darkModeEnabled.accept(storedDarkMode)
        }
        
        darkModeEnabled.asObservable().subscribe(onNext: { isEnabled in
            BaseConstant.userDefaults.set(isEnabled, forKey: "darkModeEnabled")
        }).disposed(by: disposeBag)
    }
    
    func toogleDarkMode() {
        let currentMode = darkModeEnabled.value
        darkModeEnabled.accept(!currentMode)
    }
}

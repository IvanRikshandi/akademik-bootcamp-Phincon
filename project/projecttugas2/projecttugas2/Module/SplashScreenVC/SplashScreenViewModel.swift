import Foundation
import RxSwift
import RxCocoa

class SplashViewModel {
    typealias CompletionHandler = () -> Void
    private var completionHandler: CompletionHandler?
    
    func navigateToHomeVC(completion: @escaping CompletionHandler) {
        self.completionHandler = completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            completion()
        }
    }
    
}

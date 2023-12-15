import UIKit
import Toast_Swift

class ToastManager {
    static let shared = ToastManager()
    
    private init() {}
    
    func showToastOnlyMessage(message: String) {
        DispatchQueue.main.async {
            guard let keyWindowScene = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first,
                  let topViewController = keyWindowScene.windows
                .filter({ $0.isKeyWindow })
                .first?.rootViewController
            else {
                return
            }
            topViewController.view.makeToast(message)
        }
    }
    
    func showToastWithTitle(message: String, title: String, image: UIImage, tintColor: UIColor) {
        guard let keyWindowScene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let topViewController = keyWindowScene.windows
            .filter({ $0.isKeyWindow })
            .first?.rootViewController
        else {
            return
        }
        topViewController.view.makeToast(message, position: .bottom, title: title, image: image)
    }
}

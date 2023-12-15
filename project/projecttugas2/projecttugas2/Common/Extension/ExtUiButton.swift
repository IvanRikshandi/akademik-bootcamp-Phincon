import UIKit

extension UIButton {
    func setTitle(_ title: String) {
        setTitle(.localized(title), for: .normal)
    }
}

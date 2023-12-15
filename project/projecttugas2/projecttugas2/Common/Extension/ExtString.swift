import Foundation
import UIKit

extension String {
    static func localized(_ string: String) -> String {
        return NSLocalizedString(string, comment: "")
    }
}

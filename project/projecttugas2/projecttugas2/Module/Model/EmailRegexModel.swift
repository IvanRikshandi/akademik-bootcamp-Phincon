import UIKit

struct EmailValidator {
    static let sharedInstance = EmailValidator()
    
    private let emailRegex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
    
    func isValidEmail(_ email: String) -> Bool {
        let range = NSRange(location: 0, length: email.utf16.count)
        let matches = emailRegex.matches(in: email, options: [], range: range)
        return !matches.isEmpty
    }
}

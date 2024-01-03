import Foundation

struct User {
    let email: String
    let fullname: String
    let password: String
    let phoneNumber: String

    init?(data: [String: Any]) {
        guard
            let email = data["email"] as? String,
            let fullname = data["fullname"] as? String,
            let password = data["password"] as? String,
            let phoneNumber = data["phoneNumber"] as? String
        else {
            return nil
        }
        self.email = email
        self.fullname = fullname
        self.password = password
        self.phoneNumber = phoneNumber
    }
}

import Foundation
import FirebaseAuth

class LoginViewModel {
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                print("Login failed with error: \(error.localizedDescription)")
                
            } else {
                if let uid = Firebase.uid {
                    completion(true, uid)
                    print("Login successful. UID: \(uid)")
                }
            }
        }
    }
}

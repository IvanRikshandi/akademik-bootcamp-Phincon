import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct BaseConstant{
    
    struct FakeCoffeeApi{
        static let baseURL = "https://fake-coffee-api.vercel.app"
    }
    
    struct NewsApi {
        static let newsURL =  "https://newsapi.org"
    }
    
    struct PromotionApi {
        static let promoURL = "http://localhost:3000"
    }
    
    struct PaymentApi {
        static let paymentURL = "http://localhost:3000"
    }
    
    struct CoffeeOutletApi {
        static let outletURL = "http://localhost:3000"
    }
    
    static let userDefaults = UserDefaults.standard
}

enum LoadingState {
    case loading
    case failure
    case finished
}

enum SFSymbols{
    static let homeSymbol = UIImage(systemName: "bag.circle.fill")
    static let orderSymbol = UIImage(systemName: "cart.circle.fill")
    static let newsSymbol = UIImage(systemName: "newspaper.circle.fill")
    static let profileSymbol = UIImage(systemName: "person.crop.circle.fill")
}

enum ScreenSize{
    static let width    = UIScreen.main.bounds.size.width
    static let height   = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

extension CGFloat {
    static let currentDeviceWidth = UIScreen.main.bounds.width
    static let currentDeviceHeight = UIScreen.main.bounds.height
}

enum Firebase {
    static let currentUser = Auth.auth().currentUser
    static let uid = Auth.auth().currentUser?.uid
    static let auth = Auth.auth()
    static let db = Firestore.firestore()
    static let collectionRef = db.collection("users")
    static let usersCollectionRef = db.collection("history")
    
    // MARK: - Firebase Auth
    static func signUpWithEmail(_ email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user, error == nil {
                    // User has been created and authenticated
                    completion(.success(user.uid))
                } else {
                    // Error occurred
                    completion(.failure(error ?? NSError(domain: "UnknownError", code: 0, userInfo: nil)))
                }
            }
        }
    
    // MARK: - Firestore
    
    static func saveSubCollectionHistory(uid: String, id: String, titleCoffee: String, sizeCoffe: String, qtyCoffe: Int, totalHarga: Double, time: Date, imgUrl: String, region: String, completion: @escaping (Error?) -> Void ) {
        let historyRef = db.collection("users").document(uid).collection("history")
        
        historyRef.addDocument(data: ["userId": uid, "id": id, "titleCoffe": titleCoffee, "sizeCoffee": sizeCoffe, "quantityCoffee": qtyCoffe, "totalHarga": totalHarga, "waktu": time, "imgUrl": imgUrl, "region": region]) {
            error in
            completion(error)
        }
    }
    
    static func saveSubCollectionProfile(uid: String, nickName: String, fullName: String, phoneNumber: String, birthdate: String, completion: @escaping (Error?) -> Void ) {
        let profileRef = db.collection("users").document(uid)
        
        profileRef.setData(["userId": uid,"nickName": nickName, "fullName": fullName, "phoneNumber": phoneNumber, "birthdate": birthdate]) {
            error in
            completion(error)
        }
    }
    
//    static func saveUserDataToFirestore(uid: String, email: String, fullname: String, password: String, phoneNumber: String, completion: @escaping (Error?) -> Void) {
//        let userDocument = db.collection("users").document(uid).collection("profile")
//
//        userDocument.setData(["email": email, "fullname": fullname, "password": password, "phoneNumber": phoneNumber]) { error in
//                completion(error)
//            }
//        }
    
    static func getSubCollectionHistory(uid: String, completion: @escaping ([HistoryModel]?, Error?) -> Void) {
        let historyRef = db.collection("users").document(uid).collection("history")

        historyRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var historyItems: [HistoryModel] = []
                
                for document in querySnapshot!.documents {
                    // Parse the data from the document
                    if
                        let id = document["id"] as? String,
                        let titleCoffee = document["titleCoffe"] as? String,
                        let sizeCoffee = document["sizeCoffee"] as? String,
                        let quantityCoffee = document["quantityCoffee"] as? Int,
                        let totalHarga = document["totalHarga"] as? Double,
                        let timestamp = document["waktu"] as? Timestamp,
                        let imgUrl = document["imgUrl"] as? String,
                        let region = document["region"] as? String {
                        
                        // Convert Firestore Timestamp to Swift Date
                        let date = timestamp.dateValue()
                        
                        // Create HistoryModel
                        let historyItem = HistoryModel(id: id, titleCoffee: titleCoffee, sizeCoffee: sizeCoffee, quantityCoffee: quantityCoffee, totalHarga: totalHarga, waktu: date, imgUrl: imgUrl, region: region)
                        
                        // Add history item ke array
                        historyItems.append(historyItem)
                    }
                }
                
                // Pass the array to the completion handler
                completion(historyItems, nil)
            }
        }
    }

    
    static func fetchUserData(userID: String, completion: @escaping (Result<DocumentSnapshot, Error>) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document {
                completion(.success(document))
            }
        }
    }
}

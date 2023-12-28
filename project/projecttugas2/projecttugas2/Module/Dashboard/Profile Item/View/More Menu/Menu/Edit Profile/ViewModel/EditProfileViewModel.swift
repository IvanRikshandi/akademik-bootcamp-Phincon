import Foundation

class EditProfileViewModel {
    private var uid: String
    
    init(uid: String) {
        self.uid = uid
    }
    
    func saveProfile(nickName: String, fullname: String, phoneNumber: String, birthDate: String, completion: @escaping (Bool) -> Void){
        Firebase.saveSubCollectionProfile(uid: uid, nickName: nickName, fullName: fullname, phoneNumber: phoneNumber, birthdate: birthDate ) { error in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

}


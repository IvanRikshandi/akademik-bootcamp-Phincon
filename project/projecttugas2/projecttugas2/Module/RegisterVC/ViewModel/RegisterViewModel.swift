import Foundation
import FirebaseAuth
import RxCocoa
import RxSwift

class RegisterViewModel {
    func signUp(nickName: String, fullname: String, email: String, phoneNumber: String, password: String, birthDate: String ) -> Observable<Result<String, Error>> {
        return Observable.create { observer in
            Firebase.signUpWithEmail(email, password: password) {
                result in
                switch result {
                case .success(let uid):
                    Firebase.saveSubCollectionProfile(uid: uid, nickName: nickName, fullName: fullname, phoneNumber: phoneNumber, birthdate: birthDate) { error in
                        if let error = error {
                            observer.onNext(.failure(error))
                        } else {
                            observer.onNext(.success(uid))
                        }
                        observer.onCompleted()
                    }
                case .failure(let error):
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

import UIKit
import Toast_Swift

class EditProfileViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var editProfileSubTitle: UILabel!
    @IBOutlet weak var editProfileTitle: UILabel!
    @IBOutlet weak var birthField: InputField!
    @IBOutlet weak var favoriteCoffeeField: InputField!
    @IBOutlet weak var phoneNumberField: InputField!
    @IBOutlet weak var fullnameField: InputField!
    
    
    let uid = Firebase.uid
    var editProfileViewModel: EditProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputFields()
        setupLocalizedBahasa()
    }
    
    func setupLocalizedBahasa() {
        editProfileTitle.text = .localized("editprofile")
        editProfileSubTitle.text = .localized("please")
        favoriteCoffeeField.titleText.text = .localized("nickname")
        fullnameField.titleText.text = .localized("fullname")
        phoneNumberField.titleText.text = .localized("phone")
        birthField.titleText.text = .localized("birth")
        saveBtn.setTitle("buttonsave")
    }
    
    func setupInputFields() {
        editProfileViewModel = EditProfileViewModel(uid: Firebase.uid ?? "")
        fullnameField.setup(title: "Fullname", placeholder: "Input Fullname")
        fullnameField.subtitleText.isHidden = true
        phoneNumberField.setup(title: "Phone Number", placeholder: "Input Phone Number")
        phoneNumberField.subtitleText.isHidden = true
        phoneNumberField.inputTextField.keyboardType = .numberPad
        favoriteCoffeeField.setup(title: "Nick Name", placeholder: "Input Nickname")
        favoriteCoffeeField.subtitleText.isHidden = true
        birthField.setup(title: "Birthdate", placeholder: "YYYY-MM-DD")
        birthField.inputTextField.keyboardType = .numbersAndPunctuation
        birthField.subtitleText.isHidden = true
    }
    
    func showToast(isCheck: Bool) {
        let message = isCheck ? "Profile edited success" : "Failed edited profile"
        ToastManager.shared.showToastOnlyMessage(message: message)
    }
    
    func toProfile() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        guard let fullName = fullnameField.inputTextField.text, !fullName.isEmpty,
                  let phoneNumber = phoneNumberField.inputTextField.text, !phoneNumber.isEmpty,
                  let nickname = favoriteCoffeeField.inputTextField.text, !nickname.isEmpty,
                  let birthDate = birthField.inputTextField.text, !birthDate.isEmpty else {
            return self.showToast(isCheck: false)
            }
        
        editProfileViewModel.saveProfile(nickName: nickname, fullname: fullName, phoneNumber: phoneNumber, birthDate: birthDate ){ [weak self] success in
            guard let self = self else {return}
            
            if success {
                self.showToast(isCheck: true)
                self.toProfile()
            } else {
                self.showToast(isCheck: false)
            }
        }
    }
}

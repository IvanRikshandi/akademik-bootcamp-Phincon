import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var signInBtn: UILabel!
    @IBOutlet weak var signUpText: UILabel!
    @IBOutlet weak var descripText: UILabel!
    @IBOutlet weak var nickNameField: InputField!
    @IBOutlet weak var passwordToggleBtn: UIButton!
    @IBOutlet weak var passwordField: InputField!
    @IBOutlet weak var phoneNumberField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var fullNameField: InputField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let uid = Firebase.uid
    let disposeBag = DisposeBag()
    let isPassword = BehaviorRelay<Bool>(value: false)
    let registerViewModel = RegisterViewModel()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        setupInputFields()
        localizedToBahasa()
        styleButtons()
        bindPasswordToggle()
        numericPhoneNumber()
    }
    
    func localizedToBahasa() {
        signUpText.text = .localized("signup")
        descripText.text = .localized("descrip")
        signInBtn.text = .localized("signin")
        signUpBtn.setTitle(.localized("signup"), for: .normal)
    }
    
    func setupInputFields() {
        nickNameField.setup(title: .localized("nickname"), placeholder: "Input Nickname")
        nickNameField.subtitleText.isHidden = true
        fullNameField.setup(title: .localized("fullname"), placeholder: "Input Fullname")
        fullNameField.subtitleText.isHidden = true
        emailField.setup(title: .localized("email"), placeholder: "Input Email")
        emailField.subtitleText.isHidden = true
        phoneNumberField.setup(title: .localized("phonenumber"), placeholder: "Input Phone Number")
        phoneNumberField.subtitleText.isHidden = true
        passwordField.setup(title: .localized("password"), placeholder: "Input Password")
        passwordField.inputTextField.isSecureTextEntry = true
        passwordField.subtitleText.isHidden = true
        emailField.inputTextField.addTarget(self, action: #selector(emailValidator(_:)), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toLogin))
        signInBtn.addGestureRecognizer(tapGesture)
    }
    
    func styleButtons() {
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 10
        signUpBtn.clipsToBounds = true
    }
    
    // MARK: - Password Toggle
    
    func bindPasswordToggle() {
        passwordToggleBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isPassword.accept(!(self?.isPassword.value ?? false))
            })
            .disposed(by: disposeBag)
        
        isPassword
            .subscribe(onNext: { [weak self] isVisible in
                self?.passwordField.inputTextField.isSecureTextEntry = !isVisible
                let imageName = isVisible ? "eye" : "eye.slash"
                self?.passwordToggleBtn.setImage(UIImage(systemName: imageName), for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Phone Number
    
    func numericPhoneNumber() {
        let numericOnly = phoneNumberField.inputTextField.rx.text.orEmpty
            .map { $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()}

        let formattedNumeric = numericOnly.map {string in
            var formattedString = ""
            for (index, character) in string.enumerated() {
                if index > 0 && index % 4 == 0 {
                    formattedString += " "
                }
                formattedString.append(character)
            }
            return formattedString
        }

        phoneNumberField.inputTextField.rx.text.orEmpty
            .map { String($0.prefix(15)) }
            .bind(to: phoneNumberField.inputTextField.rx.text)
            .disposed(by: disposeBag)

        formattedNumeric
            .bind(to: phoneNumberField.inputTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Validation
    
    func validateFields() -> Bool {
        guard let fullname = fullNameField.inputTextField.text, !fullname.isEmpty,
              let email = emailField.inputTextField.text, !email.isEmpty,
              let phoneNumber = phoneNumberField.inputTextField.text, !phoneNumber.isEmpty,
              let password = passwordField.inputTextField.text, !password.isEmpty
        else {
            showToast(isCheck: false)
            nickNameField.subtitleText.isHidden = false
            fullNameField.subtitleText.isHidden = false
            emailField.subtitleText.isHidden = false
            phoneNumberField.subtitleText.isHidden = false
            passwordField.subtitleText.isHidden = false
            
            nickNameField.subtitleText.text = "* required"
            fullNameField.subtitleText.text = "* required"
            emailField.subtitleText.text =  "* required"
            phoneNumberField.subtitleText.text = "* required"
            passwordField.subtitleText.text = "* required"
            return false
        }
        return true
    }
    
    // MARK: - User Registration
    
    func signUp() {
        guard let nickname = nickNameField.inputTextField.text,
              let fullname = fullNameField.inputTextField.text,
              let email = emailField.inputTextField.text,
              let phoneNumber = phoneNumberField.inputTextField.text,
              let password = passwordField.inputTextField.text
        else {
            return
        }
        
        registerViewModel.signUp(nickName: nickname, fullname: fullname, email: email, phoneNumber: phoneNumber, password: password, birthDate: "").observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let uid):
                print("User signed up successfully. UID: \(uid)")
                self.showToast(isCheck: true)
                self.clearFieldText()
            case .failure(let error):
                print("Firestore error: \(error.localizedDescription)")
                self.showToast(isCheck: false)
            }
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - UI Updates
    
    func showToast(isCheck: Bool) {
        let message = isCheck ? "User added successfully, Please Login" : "Failed to add user. Try again."
        ToastManager.shared.showToastOnlyMessage(message: message)
    }
    
    func clearFieldText() {
        nickNameField.inputTextField.text = ""
        fullNameField.inputTextField.text = ""
        emailField.inputTextField.text = ""
        phoneNumberField.inputTextField.text = ""
        passwordField.inputTextField.text = ""
        
        fullNameField.inputTextField.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    
    func navigateToLogin() {
        let loginViewController = LoginViewController()
        UINavigationBar.appearance().isHidden = true
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
    
    // MARK: - Objc
    @objc func emailValidator(_ textField: UITextField) {
        guard let email = textField.text else {return}
        let isValidEmail = EmailValidator.sharedInstance.isValidEmail(email)

        if isValidEmail {
            emailField.subtitleText.isHidden = true
            emailField.subtitleText.text = ""
        }else {
            emailField.subtitleText.isHidden = false
            emailField.subtitleText.text = "Invalid email format"
        }
    }
    
    @objc func toLogin() {
        navigateToLogin()
    }
    
    // MARK: - Button Actions
    @IBAction func signUpBtn(_ sender: Any) {
        if validateFields() {
            signUp()
        } else {
            showToast(isCheck: false)
        }
    }
    
}

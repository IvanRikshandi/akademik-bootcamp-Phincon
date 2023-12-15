import UIKit
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var buttonLogin: UIButton!
    @IBOutlet private weak var passwordField: InputField!
    @IBOutlet private weak var usernameField: InputField!
    @IBOutlet private weak var imageView: UIImageView!
    
    var userLoginKey = "isLogin"
    private let userUIDKey = "uID"
    private let loginViewModel = LoginViewModel()
    
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    
    // MARK: - UI
    private func setupUI() {
        buttonLogin.layer.cornerRadius = buttonLogin.frame.size.width / 8
        buttonLogin.clipsToBounds = true
        
        usernameField.subtitleText.isHidden = true
        usernameField.setup(title: "Username", placeholder: "Input Username")
        
        passwordField.setup(title: "Password", placeholder: "Input Password")
        passwordField.subtitleText.isHidden = true
        passwordField.inputTextField.isSecureTextEntry = true
    }
    
    // MARK: - Animation
    private func animateImageView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.15
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: imageView.center.x - 10, y: imageView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: imageView.center.x + 10, y: imageView.center.y))
        
        imageView.layer.add(animation, forKey: "position")
    }
    
    // MARK: - Action Button
    
    @IBAction private func buttonRegister(_ sender: Any) {
        let registerVC = RegisterViewController()
        UINavigationBar.appearance().isHidden = true
        navigationController?.setViewControllers([registerVC], animated: true)
    }
    
    @IBAction private func buttonLoginTapped(_ sender: Any) {
        buttonLogin.isEnabled = false

        if validateFields() {
            signIn()
        } else {
            buttonLogin.isEnabled = true
        }
    }
    func validateFields() -> Bool {
        guard let email = usernameField.inputTextField.text, !email.isEmpty,
              let password = passwordField.inputTextField.text, !password.isEmpty
        else {
            showToast(isCheck: false)
            
            usernameField.subtitleText.isHidden = false
            passwordField.subtitleText.isHidden = false
            
            usernameField.subtitleText.text = "* check"
            passwordField.subtitleText.text = "* required"
            return false
        }
        return true
    }

    func signIn() {
        guard let email = usernameField.inputTextField.text,
              let password = passwordField.inputTextField.text
        else {
            return
        }
        
        loginViewModel.signIn(email: email, password: password) { [weak self] success, uid in
            guard let self = self else {return}
            self.buttonLogin.isEnabled = true
            
            if success {
                self.showToast(isCheck: true)
                if let uid = uid {
                    self.navigateToTabbar()
                    self.userLoggedIn(true, uid: uid)
                }
            } else {
                self.showToast(isCheck: false)
            }
        }
        
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//            guard let self = self else {return}
//
//            self.buttonLogin.isEnabled = true
//
//            if let error = error {
//
//                self.showToast(isCheck: false)
//                print("Login failed with error: \(error.localizedDescription)")
//
//            } else {
//
//                // Login successful
//                self.showToast(isCheck: true)
//                if let uid = authResult?.user.uid {
//                    self.navigateToTabbar()
//                    print("Login successful. UID: \(uid)")
//                    self.userLoggedIn(true, uid: uid)
//
//                }
//            }
//        }
    }
    
    // MARK: - Message & UI Update
    func showToast(isCheck: Bool) {
        let message = isCheck ? "Welcome and enjoy your coffee" : "Please check and try again"
        let title = isCheck ? "Login Successfully" : "Login Failed"
        
        let image: UIImage?
        let tintColor: UIColor
        
        if isCheck {
            image = UIImage(systemName: "checkmark.circle.fill")
            tintColor = UIColor.systemGreen
        } else {
            image = UIImage(systemName: "xmark.circle.fill")
            tintColor = UIColor.systemRed
        }
        ToastManager.shared.showToastWithTitle(message: message, title: title, image: image!, tintColor: tintColor)
    }
    
    func clearFieldText() {
        
        usernameField.inputTextField.text = ""
        passwordField.inputTextField.text = ""
        
        usernameField.inputTextField.becomeFirstResponder()
    }
    
    // MARK: - UserDefault
    private func userLoggedIn(_ isLogin: Bool, uid: String) {
        BaseConstant.userDefaults.set(isLogin, forKey: userLoginKey)
        BaseConstant.userDefaults.set(uid, forKey: userUIDKey)
        BaseConstant.userDefaults.synchronize()
    }
    
    // MARK: - Navigation
    func navigateToTabbar() {
        let tabbarViewController = MainTabBarViewController()
        UINavigationBar.appearance().isHidden = true
        navigationController?.setViewControllers([tabbarViewController], animated: true)
    }
}

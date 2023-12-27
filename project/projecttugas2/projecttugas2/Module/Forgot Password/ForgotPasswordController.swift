import UIKit

class ForgotPasswordController: UIViewController {
    
    @IBOutlet weak var quitBtn: UIImageView!
    @IBOutlet weak var customField: InputField!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func toDismissForgot() {
        dismiss(animated: true, completion: nil)
    }
    
    func setup() {
        containerView.roundCorners(corners: .allCorners, radius: 20)
        customField.setup(title: "Email", placeholder: "example@gmail.com")
        customField.subtitleText.isHidden = true
        changePasswordBtn.roundCorners(corners: .allCorners, radius: 20)
        changePasswordBtn.addTarget(self, action: #selector(toForgot), for: .touchDown)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(quit))
        quitBtn.addGestureRecognizer(tapGesture)
    }
    
    @objc func quit() {
        toDismissForgot()
    }
    
    @objc func toForgot() {
        guard let email = customField.inputTextField.text, !email.isEmpty else {
            customField.subtitleText.isHidden = false
            customField.subtitleText.text = "Field tidak boleh kosong!"
            return }
        
        Firebase.auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                ToastManager.shared.showToastOnlyMessage(message: error.localizedDescription)
            } else {
                ToastManager.shared.showToastOnlyMessage(message: "Lihat pesan masuk di email")
                
            }
        }
        self.toDismissForgot()
    }
}

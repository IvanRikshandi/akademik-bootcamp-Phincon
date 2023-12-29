import UIKit
import Lottie

class NotificationPopUpViewController: UIViewController {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lotiAnimat: LottieAnimationView!
    
    var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       successAnimate()
    }
    
    func toDismissPopUp() {
        dismiss(animated: true) {
            self.completionHandler?()
        }
    }
    
    func successAnimate() {
        viewBackground.layer.cornerRadius = viewBackground.frame.width / 10
        lotiAnimat.animation = LottieAnimation.named("success")
        lotiAnimat.loopMode = .playOnce
        
        lotiAnimat.play()
    }
    
    @IBAction func notifPopBtn(_ sender: Any) {
        toDismissPopUp()
    }
}

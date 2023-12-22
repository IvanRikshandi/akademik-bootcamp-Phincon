import UIKit

class SplashScreenController: UIViewController {
    
    init() {
        super.init(nibName: "SplashScreenController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBOutlet var backgroundView: UIView!
    
    private let viewModel = SplashViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        styleConfiguration()
        setupVM()
    }

    func styleConfiguration() {
        let gradient = CAGradientLayer()
        let colorTop = UIColor(hex: "A4907C").cgColor
        let colorMid = UIColor(hex: "F1DEC9").cgColor
        let colorBottom = UIColor(hex: "C8B6A6").cgColor
        
        gradient.colors = [colorTop, colorMid, colorBottom]
        
        gradient.locations = [0.0, 0.8, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupVM() {
        viewModel.navigateToNext {
            [weak self] in
            self?.navigateToNextScreen()
        }
    }
    
    func navigateToNextScreen() {
        
        
        if (Firebase.currentUser != nil) {
            let tabBarViewController = MainTabBarViewController()
            navigationController?.setViewControllers([tabBarViewController], animated: true)
        } else {
            let vc = LoginViewController()
            navigationController?.setViewControllers([vc], animated: true)
        }
        
    }
    
    
}

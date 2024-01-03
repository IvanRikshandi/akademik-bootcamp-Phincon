import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
//    segue navigation
//    @IBAction func signUpButton(_ sender: Any) {
//        self.performSegue(withIdentifier: "profilViewController", sender: nil)
//    }
    
    
    
//   xib navigation
    @IBAction func xibButton(_ sender: Any) {
        let nav = LoginViewController()
                self.navigationController?.setViewControllers([nav], animated: true)
    }
    
    // story board navigation
//    @IBAction func storyboardNavigation(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "storyboardNavigationView")
//                self.navigationController?.pushViewController(destinationViewController, animated: true)
//    }
    
}

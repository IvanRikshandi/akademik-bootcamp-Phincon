import UIKit
import WebKit

class DetailWebKit: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var webKitView: WKWebView!
    
    var selectedUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webKitSetup()
    }
    
    func webKitSetup() {
        webKitView?.navigationDelegate = self
        webKitView?.scrollView.delegate = self
        guard let url = selectedUrl else { return }
        let request = URLRequest(url: url)
        webKitView?.load(request)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let navigationBarHeight: CGFloat = navigationController?.navigationBar.frame.height ?? 0
        if currentOffsetY > navigationBarHeight {
            // User has scrolled down, show the navigation bar
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            // User has scrolled up, hide the navigation bar
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
    
}

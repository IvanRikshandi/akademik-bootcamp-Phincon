import UIKit

enum ErrorType {
    case networkError
    case emptyDataError
}

protocol ErrorHandlingDelegate: AnyObject {
    func didRefresh()
}

class ErrorHandlingController: UIViewController {
    
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var titleError: UILabel!
    @IBOutlet weak var descriptionError: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    
    weak var delegate: ErrorHandlingDelegate?
    var errorType: ErrorType = .networkError

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        refreshBtn.layer.cornerRadius = 20
        refreshBtn.addTarget(self, action: #selector(toRefresh), for: .touchDown)
    }
    
    private func configure() {
        switch errorType {
        case .networkError:
            imgError.image = UIImage(named: "noconnection")
            titleError.text = "Something went wrong"
            descriptionError.text = "Sorry we couldn't access the page. Please try it again."
        case .emptyDataError:
            imgError.image = UIImage(named: "emptyerror")
            titleError.text = "Nothing to Display"
            descriptionError.text = "There are currently no items to display. Stay tuned for updates!"
        }
    }
    
    @objc func toRefresh() {
        delegate?.didRefresh()
        
        removeFromParent()
        view.removeFromSuperview()
        didMove(toParent: nil)
    }
}

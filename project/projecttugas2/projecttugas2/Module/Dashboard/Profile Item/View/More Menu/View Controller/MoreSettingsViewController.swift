import UIKit
import FloatingPanel

@objc protocol MoreSettingsDelegate: AnyObject {
    func FloatingPanelToEdit()
    func FloatingPanelToExit()
}

class MoreSettingsViewController: UIViewController{

    @IBOutlet weak var moreTableView: UITableView!
    
    weak var delegate: MoreSettingsDelegate?
    let actionBtn = MoreMenuModel.dataMoreMenu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    func setupTable() {
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.registerCellWithNib(MoreCell.self)
    }
}

extension MoreSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionBtn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moreTableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath) as! MoreCell
        let data = actionBtn[indexPath.row]
        cell.configureContent(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.FloatingPanelToEdit()
            toDismiss()
            break
        case 1:
            delegate?.FloatingPanelToExit()
            toDismiss()
        default:
            break
        }
    }
    
    func toDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

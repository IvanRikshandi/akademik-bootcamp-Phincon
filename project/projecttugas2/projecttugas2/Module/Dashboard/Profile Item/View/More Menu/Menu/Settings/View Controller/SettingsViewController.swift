import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    let actionBtn = MoreMenuModel.dataSettings
    
    func setupTable()  {
        navigationItem.title = "Settings"
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.registerCellWithNib(SettingsTableCell.self)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionBtn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        let dt = actionBtn[indexPath.row]
        cell.configureContent(data: dt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = LanguangeViewController()
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = AppModeViewController()
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

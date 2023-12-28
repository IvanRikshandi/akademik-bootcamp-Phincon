import UIKit

class LanguagesController: UIViewController {

    @IBOutlet weak var languagesTableView: UITableView!
    
    let languageData = LanguageModel.dataLanguage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        languagesTableView.registerCellWithNib(LanguageCell.self)
    }
}

extension LanguagesController: LanguageCellDelegate {
    
    func updateAppLanguage() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
            let window = sceneDelegate.window,
            let rootViewController = window.rootViewController {
            // Lakukan pembaruan atau muat ulang tampilan pada rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                if let topViewController = navigationController.topViewController {
                    // Lakukan pembaruan pada topViewController jika diperlukan
                    // misalnya, memuat ulang data atau merender ulang tampilan
                    topViewController.viewDidLoad()
                }
            }
        }
    }

    func didSelectLanguage(_ cell: LanguageCell) {
        if let indexPath = languagesTableView.indexPath(for: cell) {
            let selectedLanguage = languageData[indexPath.row].languageCode
            LanguageManager.shared.setLanguage(selectedLanguage)
            
            updateAppLanguage()
        }
    }
}

extension LanguagesController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        languageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = languagesTableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        let data = languageData[indexPath.row]
        cell.configureContent(data: data)
        return cell
        
    }
}

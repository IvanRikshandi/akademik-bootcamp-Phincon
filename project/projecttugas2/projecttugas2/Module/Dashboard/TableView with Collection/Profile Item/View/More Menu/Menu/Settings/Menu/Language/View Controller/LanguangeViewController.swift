import UIKit

class LanguangeViewController: UIViewController {

    @IBOutlet weak var languageTableView: UITableView!
    
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    let language = LanguageModel.dataLanguage
    
    func setup() {
        navigationItem.title = "Language"
        languageTableView.delegate = self
        languageTableView.dataSource = self
        languageTableView.registerCellWithNib(LanguageCell.self)
    }
}

extension LanguangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return language.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        let data = language[indexPath.row]
        cell.configureContent(data: data, isSelected: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndex = indexPath
        
        let selectedItem = language[indexPath.row]
        
        print(selectedItem)
        
    }
}

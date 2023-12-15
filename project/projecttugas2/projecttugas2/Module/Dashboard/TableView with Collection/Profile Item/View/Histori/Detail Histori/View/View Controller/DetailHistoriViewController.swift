import UIKit

class DetailHistoriViewController: UIViewController {

    @IBOutlet weak var historyTable: UITableView!
    
    var uid = Firebase.uid
    
    var historyItems: [HistoryModel] = []
    var filteredItems: [HistoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationItem.title = .localized("history")
        navigationController?.isNavigationBarHidden = false
    }
    
    func setup() {
        setupBackgroundImg()
        fetchData()
        self.filteredItems = historyItems
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.registerCellWithNib(SearchBarCell.self)
        historyTable.registerCellWithNib(DetailHistoriTableViewCell.self)
    }
    
    func setupBackgroundImg() {
        let backgroundImage = UIImage(named: "1332")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        self.historyTable.backgroundView = backgroundImageView
        backgroundImageView.alpha = 0.1
    }
    
    // MARK: - Fetch Data
    func fetchData()  {
        guard !historyItems.isEmpty else {
            print("Error: History items are empty")
            return
        }
        
        print("Success: Fetching data")
        
        // Sort historyItems by waktu in descending order
        filteredItems.sort { $0.waktu?.compare($1.waktu ?? Date()) == .orderedDescending }
        
        // Reload the table view with the sorted historyItems
        historyTable.reloadData()
        
    }
}

extension DetailHistoriViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return filteredItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = historyTable.dequeueReusableCell(forIndexPath: indexPath) as SearchBarCell
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            return cell
        case 1:
            let cell = historyTable.dequeueReusableCell(withIdentifier: "DetailHistoriTableViewCell", for: indexPath) as! DetailHistoriTableViewCell
            let historyItem = filteredItems[indexPath.row]
            cell.configureContent(data: historyItem)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension DetailHistoriViewController: SearchBarCellDelegate {    
    func searchTextChanged(_ text: String?) {
        if let searchText = text, !searchText.isEmpty {
                filteredItems = historyItems.filter {
                    ($0.titleCoffee?.lowercased().contains(searchText.lowercased()) ?? false)
                }
            } else {
                filteredItems = historyItems
            }
        historyTable.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
    }
}

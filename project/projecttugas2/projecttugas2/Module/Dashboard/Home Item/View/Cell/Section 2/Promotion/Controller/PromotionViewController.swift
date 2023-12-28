import UIKit
import CoreData

class PromotionViewController: UIViewController, PromotionCellDelegate {

    @IBOutlet weak var promoTableView: UITableView!
    
    private var promoData: PromoModel = PromoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupConfigureTable() {
        promoTableView.delegate = self
        promoTableView.dataSource = self
        promoTableView.registerCellWithNib(PromotionCell.self)
    }
    
    func loadData() {
        APIManager.shared.fetchRequest(endpoint: .getPromotion) { (result: Result<PromoModel, Error>) in
            switch result {
            case .success(let data):
                self.promoData = data
                self.savePromoToCoreData(promoModel: data)
                DispatchQueue.main.async {
                    self.promoTableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching coffee data:", error.localizedDescription)
                if let urlError = error as? URLError {
                    print("URL Error Code:", urlError.code.rawValue)
                }
            }
        }
    }
    
    func savePromoToCoreData(promoModel: PromoModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let promos = promoModel.promos {
            for promo in promos {
                if let promoEntity = NSEntityDescription.entity(forEntityName: "Promosi", in: context) {
                    let promoItem = NSManagedObject(entity: promoEntity, insertInto: context)
                    
                    promoItem.setValue(promo.id, forKey: "id")
                    promoItem.setValue(promo.kodePromo, forKey: "kode_promo")
                    promoItem.setValue(promo.nama, forKey: "nama")
                    promoItem.setValue(promo.percentage, forKey: "persentase")
                    promoItem.setValue(promo.tanggalMulai, forKey: "tanggal_mulai")
                    promoItem.setValue(promo.tanggalBerakhir, forKey: "tanggal_berakhir")
                    
                    do {
                        try context.save()
                    } catch {
                        print("failed")
                    }
                }
            }
        }
    }
}

extension PromotionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promoData.promos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = promoTableView.dequeueReusableCell(forIndexPath: indexPath) as PromotionCell
        if let data =  promoData.promos?[indexPath.row] {
            cell.configureContent(data: data)
        }
        cell.delegate = self
        return cell
    }
    
    func promotionCellDidTap(promoCode: String) {
        UIPasteboard.general.string = promoCode
        ToastManager.shared.showToastOnlyMessage(message: "Successful copying \(promoCode)")
    }
}

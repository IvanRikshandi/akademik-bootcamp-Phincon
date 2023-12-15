import UIKit
import FloatingPanel
import CoreData
import RxSwift

@objc protocol CheckoutDelegate {
    func FloatingPanelDidDismiss(index: Int)
}

class CheckOutViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var promoTitle: UILabel!
    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var discountTitle: UILabel!
    @IBOutlet weak var taxTitle: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var discountField: UITextField!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var payNowBtn: UIButton!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var checkOutView: UIView!
    @IBOutlet weak var titleCoffee: UILabel!
    
    var delegate : CheckoutDelegate?
    var promoItems: [Promo] = []
    var subTotal = ""
    var taxTotal = ""
    var discountTotal = ""
    var totalHarga = 0.0
    var qty = ""
    var size = ""
    var titles = ""
    var idCoffee = ""
    var imgUrl = ""
    var index = ""
    var region = ""
    let viewModel = BottomSheetViewModel()
    let bag = DisposeBag()
    var paymentItems: PaymentMethod?
    var selectedPaymentItem: PaymentMethodElement?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discountField.delegate = self
        initData()
        fetchCoreData()
        style()
    }
    
    func initData() {
        self.subTotalLbl.text = self.subTotal
        self.taxLbl.text = self.taxTotal
        self.discountLbl.text = self.discountTotal
        self.totalLbl.text = String(format: "$%.2f", self.totalHarga)
        self.qtyLbl.text = self.qty
        self.sizeLbl.text = self.size
        self.titleCoffee.text = self.titles
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.registerCellWithNib(PaymentCell.self)
        bindData()
    }
    
    func setupLocalizedBahasa() {
        qtyLbl.text = .localized("qty")
        sizeLbl.text = .localized("size")
        priceTitle.text = .localized("price")
        taxTitle.text = .localized("tax")
        discountTitle.text = .localized("discount")
        totalTitle.text = .localized("total")
        promoTitle.text = .localized("promocode")
        payNowBtn.setTitle("paynow")
    }
    
    func style() {
        payNowBtn.layer.cornerRadius = payNowBtn.frame.width / 10
    }
    
    func bindData() {
        viewModel.loadData()
        
        viewModel.loadingState
            .asObservable()
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                switch loading {
                case .loading:
                    print("loading")
                case .finished:
                    DispatchQueue.main.async {
                        self.paymentTableView.reloadData()
                    }
                case .failure:
                    print("error")
                }
            }).disposed(by: bag)
        
        viewModel.paymentItem
            .asObservable()
            .subscribe(onNext: {[weak self] data in
            guard let self = self else {return}
            if let data = data {
                self.paymentItems = data
            }
        }).disposed(by: bag)
    }
    
    func configureContent(with selectedItem: CartModelCoffee, index: Int, percentage: Double? = nil){
        
        self.titles = selectedItem.nama ?? ""
        self.qty = "\(selectedItem.quantity ?? 0)"
        self.size = selectedItem.size ?? ""
        self.idCoffee = "\(selectedItem.id ?? 0)"
        self.imgUrl = selectedItem.imgUrl ?? ""
        self.index = "\(index)"
        self.region = selectedItem.region ?? ""
        
        if let harga = selectedItem.harga {
            
            let discount = 0.0
            
            let discountAmount = harga * (discount / 100)
            let taxAmount = harga * 0.11
            
            let discountPrice = harga - discountAmount
            let totalPrice = discountPrice + taxAmount
            
            self.subTotal = String(format: "$%.2f", harga )
            self.taxTotal = String(format: "$%.2f", taxAmount )
            self.discountTotal = String(format: "$%.2f", discountAmount)
            self.totalHarga = totalPrice.rounded(toPlaces: 2)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text as NSString? else { return true }
        
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        updateDiscountLabel(kodePromo: updatedText)
        
        return true
    }
    
    func updateDiscountLabel(kodePromo: String) {
        if let promo = findPromoByKodePromo(kodePromo: kodePromo) {
            let discountAmount = totalHarga * (promo.percentage! / 100.0)
            let totalPrice = totalHarga.rounded(toPlaces: 2) - discountAmount.rounded(toPlaces: 2)
            
            discountTotal = String(format: "$%.2f", discountAmount)
            totalLbl.text = String(format: "$%.2f", totalPrice)
            discountLbl.text = discountTotal
        } else {
            discountTotal = "$0.00"
            totalLbl.text = String(format: "$%.2f", totalHarga)
            discountLbl.text = discountTotal
        }
    }
    
    func findPromoByKodePromo(kodePromo: String) -> Promo? {
        return promoItems.first { $0.kodePromo == kodePromo }
    }
    
    // MARK: Action
    
    @IBAction func payNowBtn(_ sender: Any) {
        
        if selectedPaymentItem != nil {
            if let index = Int(self.index){
                savePaymentCoreData()
                removeDataFrmCoreData(index: index)
                toDismiss(index: index)
                toPaymentDetail()
            }
        } else {
            showToast(isCheck: false)
        }
    }
    
    // MARK: Function
    
    func fetchCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Promosi")
        
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject], !results.isEmpty {
                for result in results {
                    guard
                        let id = result.value(forKey: "id") as? Int,
                        let kodePromo = result.value(forKey: "kode_promo") as? String,
                        let nama = result.value(forKey: "nama") as? String,
                        let percentage = result.value(forKey: "persentase") as? Double,
                        let tanggalMulai = result.value(forKey: "tanggal_mulai") as? String,
                        let tanggalBerakhir = result.value(forKey: "tanggal_berakhir") as? String
                    else {
                        return
                    }
                    
                    let promoItem = Promo(id: id, nama: nama, deskripsi: nil, tanggalMulai: tanggalMulai, tanggalBerakhir: tanggalBerakhir, kodePromo: kodePromo, image: nil, percentage: percentage)
                    
                    promoItems.append(promoItem)
                }
            }
        } catch let error as NSError {
            print("Failed to fetch data: \(error), \(error.userInfo)")
        }
    }
    
    func removeDataFrmCoreData(index: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            if let cartItems = fetchedResults as? [NSManagedObject]{
                
                let itemselected = cartItems[index]
                
                context.delete(itemselected)
                
                try context.save()
                showToast(isCheck: true)
            }
        }catch{
            showToast(isCheck: false)
        }
    }
    
    func savePaymentCoreData() {
        guard let userID = Firebase.auth.currentUser?.uid else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let replacingTax = taxTotal.replacingOccurrences(of: "$", with: "")
        let replacingDiscount = discountTotal.replacingOccurrences(of: "$", with: "")
        
        if let payment = NSEntityDescription.entity(forEntityName: "Payment", in: context) {
            let paymentObject = NSManagedObject(entity: payment, insertInto: context)
            
            paymentObject.setValue(userID, forKey: "userID")
            paymentObject.setValue(Double(replacingTax), forKey: "taxCoffee")
            paymentObject.setValue(Double(replacingDiscount), forKey: "discount")
            paymentObject.setValue(totalHarga, forKey: "totalHarga")
            paymentObject.setValue(titles, forKey: "namaCoffee")
            paymentObject.setValue(size, forKey: "sizeCoffee")
            paymentObject.setValue(imgUrl, forKey: "imgUrl")
            paymentObject.setValue(idCoffee, forKey: "id")
            paymentObject.setValue(Int(qty), forKey: "quantityCoffee")
            paymentObject.setValue(selectedPaymentItem?.id, forKey: "paymentId")
            paymentObject.setValue(selectedPaymentItem?.name, forKey: "paymentName")
            paymentObject.setValue(selectedPaymentItem?.logo, forKey: "paymentLogo")
            paymentObject.setValue(selectedPaymentItem?.virtualAccount, forKey: "paymentVA")
            paymentObject.setValue(region, forKey: "region")
            
            do {
                try context.save()
            } catch {
                print("failed")
            }
        }
    }
    
    func toDismiss(index: Int) {
        self.dismiss(animated: true, completion: nil)
        delegate?.FloatingPanelDidDismiss(index: index)
    }
    
    func toPaymentDetail() {
        let vc = PaymentDetail()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showToast(isCheck: Bool) {
        let message = isCheck ? "Check out success" : "Failed to check out. Try again."
        ToastManager.shared.showToastOnlyMessage(message: message)
    }
}

extension CheckOutViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentItems?.paymentMethods?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentTableView.dequeueReusableCell(forIndexPath: indexPath) as PaymentCell
        if let data = paymentItems?.paymentMethods?[indexPath.row] {
            cell.configureContent(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPayment = paymentItems?.paymentMethods?[indexPath.row] {
            self.selectedPaymentItem = selectedPayment
        }
    }
}

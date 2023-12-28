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
    var paymentItems: PaymentMethod?
    var selectedPaymentItem: PaymentMethodElement?
    var checkoutInfo = CheckoutInfo()
    let viewModel = BottomSheetViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initData()
        fetchCoreData()
    }
    
    // MARK: - Initialization

    func setupUI() {
        discountField.delegate = self
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.registerCellWithNib(PaymentCell.self)
        style()
        bindData()
    }
    
    func initData() {
        self.subTotalLbl.text = checkoutInfo.subTotal
        self.taxLbl.text = checkoutInfo.taxTotal
        self.discountLbl.text = checkoutInfo.discountTotal
        self.totalLbl.text = String(format: "$%.2f", checkoutInfo.totalHarga)
        self.qtyLbl.text = checkoutInfo.qty
        self.sizeLbl.text = checkoutInfo.size
        self.titleCoffee.text = checkoutInfo.titles
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
    
    // MARK: - Binding Data
    
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
        
        self.checkoutInfo.titles = selectedItem.nama ?? ""
        self.checkoutInfo.qty = "\(selectedItem.quantity ?? 0)"
        checkoutInfo.size = selectedItem.size ?? ""
        checkoutInfo.idCoffee = "\(selectedItem.id ?? 0)"
        checkoutInfo.imgUrl = selectedItem.imgUrl ?? ""
        checkoutInfo.index = "\(index)"
        checkoutInfo.region = selectedItem.region ?? ""
        
        if let harga = selectedItem.harga {
            
            let discount = 0.0
            
            let discountAmount = harga * (discount / 100)
            let taxAmount = harga * 0.11
            
            let discountPrice = harga - discountAmount
            let totalPrice = discountPrice + taxAmount
            
            checkoutInfo.subTotal = String(format: "$%.2f", harga )
            checkoutInfo.taxTotal = String(format: "$%.2f", taxAmount )
            checkoutInfo.discountTotal = String(format: "$%.2f", discountAmount)
            checkoutInfo.totalHarga = totalPrice.rounded(toPlaces: 2)
        }
    }
    
    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text as NSString? else { return true }
        
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        updateDiscountLabel(kodePromo: updatedText)
        
        return true
    }
    
    // MARK: - Update Discount Label

    func updateDiscountLabel(kodePromo: String) {
        if let promo = findPromoByKodePromo(kodePromo: kodePromo) {
            let discountAmount = checkoutInfo.totalHarga * (promo.percentage! / 100.0)
            let totalPrice = checkoutInfo.totalHarga.rounded(toPlaces: 2) - discountAmount.rounded(toPlaces: 2)
            
            checkoutInfo.discountTotal = String(format: "$%.2f", discountAmount)
            totalLbl.text = String(format: "$%.2f", totalPrice)
            discountLbl.text = checkoutInfo.discountTotal
        } else {
            checkoutInfo.discountTotal = "$0.00"
            totalLbl.text = String(format: "$%.2f", checkoutInfo.totalHarga)
            discountLbl.text = checkoutInfo.discountTotal
        }
    }
    
    // MARK: - Find Promo by Kode Promo

    func findPromoByKodePromo(kodePromo: String) -> Promo? {
        return promoItems.first { $0.kodePromo == kodePromo }
    }
    
    // MARK: - Action
    
    @IBAction func payNowBtn(_ sender: Any) {
        if selectedPaymentItem != nil {
            if let index = Int(checkoutInfo.index){
                savePaymentCoreData()
                removeDataFrmCoreData(index: index)
                toDismiss(index: index)
                toPaymentDetail()
            }
        } else {
            showToast(isCheck: false)
        }
    }
    
    // MARK: - Core Data Operations

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
        } catch {
            showToast(isCheck: false)
        }
    }
    
    func savePaymentCoreData() {
        guard let userID = Firebase.auth.currentUser?.uid else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let replacingTax = checkoutInfo.taxTotal.replacingOccurrences(of: "$", with: "")
        let replacingDiscount = checkoutInfo.discountTotal.replacingOccurrences(of: "$", with: "")
        
        if let payment = NSEntityDescription.entity(forEntityName: "Payment", in: context) {
            let paymentObject = NSManagedObject(entity: payment, insertInto: context)
            
            paymentObject.setValue(userID, forKey: "userID")
            paymentObject.setValue(Double(replacingTax), forKey: "taxCoffee")
            paymentObject.setValue(Double(replacingDiscount), forKey: "discount")
            paymentObject.setValue(checkoutInfo.totalHarga, forKey: "totalHarga")
            paymentObject.setValue(checkoutInfo.titles, forKey: "namaCoffee")
            paymentObject.setValue(size, forKey: "sizeCoffee")
            paymentObject.setValue(checkoutInfo.imgUrl, forKey: "imgUrl")
            paymentObject.setValue(checkoutInfo.idCoffee, forKey: "id")
            paymentObject.setValue(Int(checkoutInfo.qty), forKey: "quantityCoffee")
            paymentObject.setValue(selectedPaymentItem?.id, forKey: "paymentId")
            paymentObject.setValue(selectedPaymentItem?.name, forKey: "paymentName")
            paymentObject.setValue(selectedPaymentItem?.logo, forKey: "paymentLogo")
            paymentObject.setValue(selectedPaymentItem?.virtualAccount, forKey: "paymentVA")
            paymentObject.setValue(checkoutInfo.region, forKey: "region")
            
            do {
                try context.save()
            } catch {
                print("Failed to save payment data")
            }
        }
    }
    
    
    // MARK: - Navigation

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

import UIKit
import Kingfisher
import RxSwift
import CoreData

class PaymentDetail: UIViewController {

    @IBOutlet weak var totalPaymentTxt: UILabel!
    @IBOutlet weak var noRekText: UILabel!
    @IBOutlet weak var paymentDeadline: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var copyLbl: UILabel!
    @IBOutlet weak var rekeningLbl: UILabel!
    @IBOutlet weak var imgBank: UIImageView!
    @IBOutlet weak var bankTitle: UILabel!
    @IBOutlet weak var clockLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    private let bag = DisposeBag()
    var fetchData: [PaymentDetailModel] = []
    var countdownTimer = 1 * 60
    var timer = Timer()
    var time = Date()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        actionBtn()
        fetchCoreData()
        localizeBahasa()
    }
    
// MARK: - Configuration Function
    func localizeBahasa() {
        paymentDeadline.text = .localized("paymentdeadline")
        noRekText.text = .localized("accountnumber")
        copyLbl.text = .localized("copy")
        totalPaymentTxt.text = .localized("totalpayment")
        confirmBtn.setTitle(.localized("confirm"), for: .normal)
    }
    
    func setupUI() {
        navigationController?.hidesBottomBarWhenPushed = true
        containerView.makeCornerRadius(10)
        updateClock()
        startCountDown()
    }
    
// MARK: - Timer
    
    func updateClock() {
            Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).map {
                _ in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                return dateFormatter.string(from: Date())
            }
            .bind(to: dateLbl.rx.text)
            .disposed(by: bag)
        }
    
    func startCountDown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if countdownTimer > 0 {
            countdownTimer -= 1
            updateCountDownLabel()
            
        } else {
            stopCountDown()
            removeAllDataFromCoreData()
            showToast(isCheck: false)
            toCart()
        }
    }
    
    func stopCountDown() {
        timer.invalidate()
    }
    
    func updateCountDownLabel() {
        let minutes = countdownTimer / 60
        let seconds = countdownTimer % 60
        clockLbl.text = String(format: "%02d:%02d", minutes, seconds)
    }

// MARK: - Get Core Data
    
    func fetchCoreData() {
        guard let userID = Firebase.auth.currentUser?.uid, let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Payment")
        
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            
            if let cartItems = fetchedResults as? [NSManagedObject] {
                for item in cartItems {
                    if let name = item.value(forKey: "namaCoffee") as? String,
                       let id = item.value(forKey: "id") as? String,
                       let sizeCoffee = item.value(forKey: "sizeCoffee") as? String,
                       let quantity = item.value(forKey: "quantityCoffee") as? Int,
                       let img = item.value(forKey: "imgUrl") as? String,
                       let totalHarga = item.value(forKey: "totalHarga") as? Double,
                       let tax = item.value(forKey: "taxCoffee") as? Double,
                       let discount = item.value(forKey: "discount") as? Double,
                       let paymentId = item.value(forKey: "paymentId") as? String,
                       let paymentLogo = item.value(forKey: "paymentLogo") as? String,
                       let paymentName = item.value(forKey: "paymentName") as? String,
                       let paymentVA = item.value(forKey: "paymentVA") as? String,
                       let region = item.value(forKey: "region") as? String {
                        let item = PaymentDetailModel(userID: userID, id: id, namaCoffee: name, sizeCoffee: sizeCoffee, region: region, imgUrl: img, quantityCoffee: quantity, taxCoffee: tax, totalHarga: totalHarga, discount: discount, paymentId: paymentId, paymentLogo: paymentLogo, paymentName: paymentName, paymentVA: paymentVA)
                        fetchData.append(item)
                        print(item)
                        bankTitle.text = paymentName
                        rekeningLbl.text = paymentVA
                        totalLbl.text = "$\(totalHarga)"
                        imgBank.kf.setImage(with: URL(string: paymentLogo))
                    }
                }
            }
        } catch let error as NSError {
            print("Failed to fetch data: \(error), \(error.userInfo)")
        }
    }

// MARK: - Navigation
    
    func actionBtn() {
        confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
    }
    
    @objc func confirmBtnTapped()  {
        guard let userID = Firebase.auth.currentUser?.uid, let data = fetchData.first else {
            self.removeAllDataFromCoreData()
            self.toCart()
            self.showToast(isCheck: false)
            return }
        Firebase.saveSubCollectionHistory(uid: userID, id: data.id ?? "", titleCoffee: data.namaCoffee ?? "", sizeCoffe: data.sizeCoffee ?? "", qtyCoffe: data.quantityCoffee ?? 0, totalHarga: data.totalHarga ?? 0, time: time, imgUrl: data.imgUrl ?? "", region: data.region ?? "", completion:  { error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
                self.showToast(isCheck: false)
            } else {
                self.removeAllDataFromCoreData()
                self.toCart()
                self.toPopUp()
                self.showToast(isCheck: true)
            }
        })
    }
    
    func removeAllDataFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Payment")

        do {
            let fetchedResults = try context.fetch(fetchRequest)

            for case let item as NSManagedObject in fetchedResults {
                context.delete(item)
            }

            try context.save()
            print("All Data Removed Successfully")
        } catch {
            print("Failed to remove all data: \(error.localizedDescription)")
        }
    }
    
    func toPopUp() {
        let vc = NotificationPopUpViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func showToast(isCheck: Bool) {
        let message = isCheck ? "Payment success" : "Payment Failed"
        ToastManager.shared.showToastOnlyMessage(message: message)
    }
    
    func toCart() {
        navigationController?.popViewController(animated: true)
    }
}

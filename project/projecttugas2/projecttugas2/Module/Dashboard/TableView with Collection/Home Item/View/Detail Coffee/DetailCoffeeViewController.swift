
import UIKit
import CoreData
import Kingfisher

protocol DetailCoffeeViewDelegate {
    func didToCart(withID id: Int)
}

class DetailCoffeeViewController: UIViewController {
    
    @IBOutlet weak var roastLvlTitle: UILabel!
    @IBOutlet weak var weightTitle: UILabel!
    @IBOutlet weak var addCartBtn: UIButton!
    @IBOutlet weak var sizeText: UILabel!
    @IBOutlet weak var roastText: UILabel!
    @IBOutlet weak var weightText: UILabel!
    @IBOutlet weak var locText: UILabel!
    @IBOutlet weak var incrementText: UILabel!
    @IBOutlet weak var deskripsiText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    
    var selectedData: CoffeeModelElement?
    var currentValue: Int = 1
    var priceQuantity: Double = 0.0
    var selectedSize: String = "S"
    var weightCoffee: Int = 0, roastCofffee: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateLbl()
        setupLocalizedBahasa()
    }
    
    func setupLocalizedBahasa() {
        addCartBtn.setTitle("cartbutton")
        sizeText.text = .localized("sizedetail")
        weightTitle.text = .localized("weight")
        roastLvlTitle.text = .localized("roastlvl")
    }
    
    func updateLbl() {
        incrementText.text = "\(currentValue)"
        sizeText.text = "Size : \(selectedSize)"
    }
    
    func setup(){
        if let coffeeData = selectedData {
            titleText.text = coffeeData.name
            deskripsiText.text = coffeeData.description
            priceQuantity = coffeeData.price ?? 0
            locText.text = coffeeData.region
            priceText.text = "$\(priceQuantity)"
            weightCoffee = coffeeData.weight ?? 0
            weightText.text = "\(weightCoffee)"
            roastCofffee = coffeeData.roastLevel ?? 0
            roastText.text = "\(roastCofffee)"
            sizeText.text = "Size : \(selectedSize)"
            
            if let validURl = selectedData?.imageURL {
                imageDetail.kf.setImage(with: URL(string: validURl), placeholder: UIImage(named: "notavail"))
            }
        }
    }
    
    func showToast(isCheck: Bool) {
        let message = isCheck ? "Success add to cart" : "Failed add to cart"

        ToastManager.shared.showToastOnlyMessage(message: message)
    }
    
    @IBAction func addCartButton(_ sender: Any) {
        guard let coffeeData = selectedData, let userID = Firebase.auth.currentUser?.uid else {
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext

        if let cartEntity = NSEntityDescription.entity(forEntityName: "Cart", in: context) {
            let cartItem = NSManagedObject(entity: cartEntity, insertInto: context)
            
            cartItem.setValue(userID, forKey: "userID")
            cartItem.setValue(coffeeData.name, forKey: "namaCoffee")
            cartItem.setValue(coffeeData.id, forKey: "id")
            cartItem.setValue(coffeeData.imageURL, forKey: "imgUrlCoffee")
            cartItem.setValue(coffeeData.region, forKey: "region")
            cartItem.setValue(currentValue, forKey: "quantityCoffee")
            cartItem.setValue(selectedSize, forKey: "sizeCoffee")
            cartItem.setValue(priceQuantity * Double(currentValue), forKey: "totHargaCoffee")
            do {
                try context.save()
                print(cartItem)
                showToast(isCheck: true)
            }catch {
                showToast(isCheck: false)
                print("Failed to save item to cart: \(error)")
            }
        }
    }
    
    @IBAction func minusBtn(_ sender: Any) {
        if currentValue > 1 {
            currentValue -= 1
            let format = String(format: "%.2f", (priceQuantity * Double(currentValue)))
            priceText.text = "$\(format)"
            updateLbl()
        }
    }
    @IBAction func plusBtn(_ sender: Any) {
        currentValue += 1
        if currentValue >= 2 {
            let format = String(format: "%.2f", (priceQuantity * Double(currentValue)))
            priceText.text = "$\(format)"
        }
        updateLbl()
    }

    @IBAction func sizeLBtn(_ sender: Any) {
        selectedSize = "L"
        updateLbl()
    }
    @IBAction func sizeMBtn(_ sender: Any) {
        selectedSize = "M"
        updateLbl()
    }
    @IBAction func sizeSBtn(_ sender: Any) {
        selectedSize = "S"
        updateLbl()
    }
}

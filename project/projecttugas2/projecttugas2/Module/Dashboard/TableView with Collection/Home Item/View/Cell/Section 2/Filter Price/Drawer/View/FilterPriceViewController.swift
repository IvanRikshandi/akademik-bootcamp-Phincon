import UIKit

protocol FilterDataDelegate: AnyObject {
    func didFilterPrice(minPrice: Double, maxPrice: Double)
    func didReset()
}

class FilterPriceViewController: UIViewController {

    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnValid: UIButton!
    @IBOutlet weak var maxPriceField: UITextField!
    @IBOutlet weak var minPriceField: UITextField!
    
    weak var delegate: FilterDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionBtn()
    }
    
    func actionBtn() {
        btnValid.addTarget(self, action: #selector(didFiltered), for: .touchUpInside)
        btnReset.addTarget(self, action: #selector(didReset), for: .touchUpInside)
    }
    
    @objc func didFiltered() {
        guard let minPriceText = minPriceField.text, let maxPriceText = maxPriceField.text, let minPrice = Double(minPriceText), let maxPrice = Double(maxPriceText) else {
            print("Invalid Input")
            return
        }
        
        delegate?.didFilterPrice(minPrice: minPrice, maxPrice: maxPrice)
        
        hideFilterPrice()
    }
    
    @objc func didReset() {
        minPriceField.text = ""
        maxPriceField.text = ""
        
        delegate?.didReset()
        hideFilterPrice()
    }
    
    @objc func hideFilterPrice() {
        if let filterVc = tabBarController?.children.first(where: {$0 is FilterPriceViewController}) as? FilterPriceViewController {
            UIView.animate(withDuration: 0.3, animations: {
                filterVc.view.frame.origin.x -= filterVc.view.frame.width
            }) { (_) in
                filterVc.view.removeFromSuperview()
                filterVc.removeFromParent()
            }
        }
    }
    
}

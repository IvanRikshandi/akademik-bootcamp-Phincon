import UIKit

protocol CartBtnCellDelegate: AnyObject {
    func didTapCheckout()
}

class CartBtnCell: UITableViewCell {
    
    @IBOutlet weak var checkOutBtn: UILabel!
    
    
    weak var delegate: CartBtnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toCheckout))
        checkOutBtn.addGestureRecognizer(tapGesture)
    }
    
    @objc func toCheckout() {
        delegate?.didTapCheckout()
    }
}

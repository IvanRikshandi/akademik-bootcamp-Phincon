import UIKit
import Kingfisher

protocol PaymentCellDelegate: AnyObject {
    func didSelectPayment(_ cell: PaymentCell)
}

class PaymentCell: UITableViewCell {
    
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var imgPayment: UIImageView!
    
    weak var delegate: PaymentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateUI(selected: selected)
        
        if selected {
            delegate?.didSelectPayment(self)
        }
    }
    
    func setupUI() {
        checkMark.isHidden = true
    }
    
    func updateUI(selected: Bool) {
        checkMark.isHidden = !isSelected
    }
    
    func configureContent(data: PaymentMethodElement) {
        paymentLbl.text = data.name
        if let validUrl = data.logo {
            imgPayment.kf.setImage(with: URL(string: validUrl), placeholder: UIImage(named: "notavail"))
        }
        updateUI(selected: isSelected)
    }
}

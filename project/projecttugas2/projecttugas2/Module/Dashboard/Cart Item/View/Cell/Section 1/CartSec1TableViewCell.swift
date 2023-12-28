import UIKit

class CartSec1TableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleCart: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleCart.text = .localized("titleCart")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

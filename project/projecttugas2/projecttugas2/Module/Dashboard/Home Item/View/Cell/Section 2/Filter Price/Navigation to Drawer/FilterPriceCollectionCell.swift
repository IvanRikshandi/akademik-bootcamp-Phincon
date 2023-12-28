import UIKit

class FilterPriceCollectionCell: UICollectionViewCell {

    @IBOutlet weak var filterPriceBtn: UIView!
    
    weak var delegate: CategoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFilterPrice))
        filterPriceBtn.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapFilterPrice() {
        delegate?.didFilterPrice()
    }
}


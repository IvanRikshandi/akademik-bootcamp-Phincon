import UIKit

protocol PromotionCellDelegate: AnyObject {
    func promotionCellDidTap(promoCode: String)
}

class PromotionCell: UITableViewCell {

    @IBOutlet weak var imagePromo: UIImageView!
    @IBOutlet weak var deskripsiPromo: UILabel!
    @IBOutlet weak var kodePromo: UILabel!
    @IBOutlet weak var namaPromo: UILabel!
    
    weak var delegate: PromotionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureContent(data: Promo) {
        self.namaPromo.text = data.nama
        self.deskripsiPromo.text = data.deskripsi
        self.kodePromo.text = data.kodePromo
        let imageView = UIImage(named: "hotsale")
        self.imagePromo.image = imageView
    }
    
    @objc private func cellTapped() {
        if let promoCode = kodePromo.text {
            delegate?.promotionCellDidTap(promoCode: promoCode)
        }
    }
}

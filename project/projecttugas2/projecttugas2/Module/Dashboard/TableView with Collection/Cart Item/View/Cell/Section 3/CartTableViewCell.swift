
import UIKit
import Kingfisher
import FloatingPanel

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkUncheck: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgUrlKopi: UIImageView!
    @IBOutlet weak var hargaKopi: UILabel!
    @IBOutlet weak var titleKopi: UILabel!
    @IBOutlet weak var quantityKopi: UILabel!
    @IBOutlet weak var sizeKopi: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureContent(data: CartModelCoffee){
        self.titleKopi.text = data.nama
        self.hargaKopi.text = "$\(data.harga?.rounded(toPlaces: 2) ?? 0)"
        self.quantityKopi.text = "Qty: \(data.quantity ?? 0)"
        self.sizeKopi.text = "Size: \(data.size ?? "")"
        if let validURl = data.imgUrl {
            imgUrlKopi.kf.setImage(with: URL(string: validURl), placeholder: UIImage(named: "notavail"))
        }
    }
    
    func style() {
        containerView.layer.cornerRadius = containerView.frame.width / 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.masksToBounds = false
    }

}

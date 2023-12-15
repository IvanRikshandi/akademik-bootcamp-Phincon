import UIKit
import Kingfisher

class DetailHistoriTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hargaLbl: UILabel!
    @IBOutlet weak var waktuLbl: UILabel!
    @IBOutlet weak var grindLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgUrl: UIImageView!
    
    let dateFormat = "yyyy-MM-dd"
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureContent(data: HistoryModel) {
        self.titleLbl.text = data.titleCoffee
        self.grindLbl.text = data.region
        self.hargaLbl.text = "$\(data.totalHarga ?? 0.0)"
        if let waktuDate = data.waktu {
            dateFormatter.dateFormat = dateFormat
            
            let formattedDate = dateFormatter.string(from: waktuDate)
            self.waktuLbl.text = formattedDate
        }
        if let validUrl = data.imgUrl {
            imgUrl.kf.setImage(with: URL(string: validUrl), placeholder: UIImage(named: "notavail"))
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

import UIKit
import Kingfisher

class HistoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewHistory: UIView!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgCoffee: UIImageView!
    
    let dateFormat = "yyyy-MM-dd"
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    func style() {
        imgCoffee.layer.shadowColor = UIColor.black.cgColor
        imgCoffee.layer.shadowOffset = CGSize(width: 0, height: 1)
        imgCoffee.layer.shadowRadius = 1
        imgCoffee.layer.shadowOpacity = 0.2
        imgCoffee.layer.masksToBounds = false
        imgCoffee.layer.cornerRadius = imgCoffee.frame.height / 10
        self.clipsToBounds = true
    }
    
    func configureContent(data: HistoryModel){
        self.titleLbl.text = data.titleCoffee
        if let waktuDate = data.waktu {
            dateFormatter.dateFormat = dateFormat
            
            let formattedDate = dateFormatter.string(from: waktuDate)
            self.subtitleLbl.text = formattedDate
        }
        if let validURl = data.imgUrl {
            imgCoffee.kf.setImage(with: URL(string: validURl), placeholder: UIImage(named: "notavail"))
        }
    }
}

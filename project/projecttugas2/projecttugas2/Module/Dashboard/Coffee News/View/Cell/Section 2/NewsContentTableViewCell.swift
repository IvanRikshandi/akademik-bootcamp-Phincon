import UIKit
import Kingfisher

class NewsContentTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var authorNews: UILabel!
    @IBOutlet weak var descriptionNews: UILabel!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var imgUrl: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.layer.cornerRadius = viewBackground.frame.width / 20
        viewBackground.layer.shadowColor = UIColor.black.cgColor
        viewBackground.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewBackground.layer.shadowRadius = 2
        viewBackground.layer.shadowOpacity = 0.2
        viewBackground.layer.masksToBounds = false
        imgUrl.layer.cornerRadius = imgUrl.frame.width / 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureContent(data: Article) {
        self.titleNews.text = data.title
        self.descriptionNews.text = data.description
        self.authorNews.text = data.author
        if let validUrl = data.urlToImage {
            imgUrl.kf.setImage(with: URL(string: validUrl), placeholder: UIImage(named: "notavail"))
        }
    }
    
}

import UIKit
import Kingfisher

class ContentCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var hargaCoffee: UILabel!
    @IBOutlet weak var titleCoffee: UILabel!
    @IBOutlet weak var imgUrl: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = containerView.frame.height / 10
        containerView.layer.applyShadow(color: .black, offset: CGSize(width: 0, height: 1), radius: 2, opacity: 0.2)
        imgUrl.layer.cornerRadius = imgUrl.frame.width / 10
        
    }
    
    func configureContent(data: CoffeeModelElement){
        self.titleCoffee.text = data.name ?? "Coffee habis"
        self.hargaCoffee.text = String(format: "$%.2f", data.price! )
        let processor = DownsamplingImageProcessor(size: CGSize(width: 320, height: 320))
        if let validURl = data.imageURL {
            imgUrl.kf.setImage(with: URL(string: validURl), placeholder: UIImage(named: "notavail"), options: [
                .processor(processor),
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25)),
            ])
        }
    }
}

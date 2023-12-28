import UIKit
import Kingfisher

class CarouselCell: UICollectionViewCell {

    @IBOutlet weak var imageAd: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureContent(data: CarouselCell) {
        self.imageAd.image = data.imageAd.image
    }
}

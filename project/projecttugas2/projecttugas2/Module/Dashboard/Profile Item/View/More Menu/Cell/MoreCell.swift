import UIKit

class MoreCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageSymbol: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureContent(data: MoreMenuModel) {
        titleLbl.text = data.title
        imageSymbol.image = UIImage(systemName: data.logo)
    }
}

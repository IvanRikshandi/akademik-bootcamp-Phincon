import UIKit

class SettingsTableCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureContent(data: MoreMenuModel) {
        titleLbl.text = data.title
        imgLogo.image = UIImage(systemName: data.logo)
    }
    
}

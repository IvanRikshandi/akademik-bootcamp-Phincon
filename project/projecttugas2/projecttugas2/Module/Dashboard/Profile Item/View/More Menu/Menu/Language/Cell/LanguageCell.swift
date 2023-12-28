import UIKit

protocol LanguageCellDelegate: AnyObject {
    func didSelectLanguage(_ cell: LanguageCell)
}

class LanguageCell: UITableViewCell {
    
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var languageLbl: UILabel!
    
    weak var delegate: LanguageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateUI(selected: selected)
        
        if selected {
            delegate?.didSelectLanguage(self)
        }
    }
    
    func setupUI() {
        checkMark.isHidden = true
    }
    
    func updateUI(selected: Bool) {
        checkMark.isHidden = !isSelected
    }
    
    func configureContent(data: LanguageModel) {
        self.languageLbl.text = data.title
        updateUI(selected: isSelected)
    }

}

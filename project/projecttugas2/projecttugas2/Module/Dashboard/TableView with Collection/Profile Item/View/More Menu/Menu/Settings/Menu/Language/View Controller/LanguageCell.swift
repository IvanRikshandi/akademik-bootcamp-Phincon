//
//  LanguageCell.swift
//  projecttugas2
//
//  Created by Phincon on 07/12/23.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var lblLanguage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureContent(data: LanguageModel, isSelected: Bool) {
        lblLanguage.text = data.title
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected{
                setSelected()
            } else {
                setUnselected()
            }
        }
    }
    
    func setSelected() {
        checkImg.isHidden = false
        checkImg.tintColor = UIColor.red
        checkImg.image = UIImage(systemName: "checkmark")
    }
    
    func setUnselected() {
        checkImg.isHidden = true
    }
    
}

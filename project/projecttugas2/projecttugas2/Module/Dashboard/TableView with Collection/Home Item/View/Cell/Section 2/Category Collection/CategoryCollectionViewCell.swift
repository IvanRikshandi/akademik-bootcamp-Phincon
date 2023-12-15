import UIKit
import RxSwift
import RxCocoa

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var filterLbl: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    func style() {
        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewContainer.layer.shadowRadius = 2
        viewContainer.layer.shadowOpacity = 0.1
        viewContainer.layer.masksToBounds = false
    }
    
    func configureContent(_ grindOption: String, isSelected: Bool){
        filterLbl.text = grindOption
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected{
                setSelected()
            }
            else {
                setUnselected()
            }
        }
    }
    
    func setSelected() {
        viewContainer.backgroundColor = .brown
        filterLbl.textColor = UIColor.white
        imgCheck.tintColor = UIColor.yellow
        imgCheck.image = UIImage(systemName: "checkmark.square.fill")
    }
    func setUnselected() {
        viewContainer.backgroundColor = .white
        filterLbl.textColor = UIColor.gray
        imgCheck.tintColor = UIColor.gray
        imgCheck.image = UIImage(systemName: "square")
    }
}

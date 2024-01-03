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
        setupUI()
    }
    
    func setupUI() {
        viewContainer.layer.cornerRadius = 10
        viewContainer.layer.applyShadow(color: .black, offset: CGSize(width: 0, height: 2), radius: 2, opacity: 0.1)
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

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

protocol CategoryTableViewCellDelegate: AnyObject {
    func didSelectGrindOption(_ grindOption: [String])
    func didTapPromoView(in Cell: CategoryTableViewCell)
    func didFilterPrice()
}

class CategoryTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var promoView: UIView!
    @IBOutlet weak var collectionFilter: UICollectionView!
    
    weak var delegate: CategoryTableViewCellDelegate?
    
    var selectedGrindOptions: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupGesture()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        collectionFilter.delegate = self
        collectionFilter.dataSource = self
        collectionFilter.registerCellWithNib(CategoryCollectionViewCell.self)
        collectionFilter.registerCellWithNib(FilterPriceCollectionCell.self)
        UINavigationBar.appearance().isHidden = false
        collectionFilter.allowsMultipleSelection = true
    }
    
    func setupGesture() {
        promoView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(promoTappedView))
        promoView.addGestureRecognizer(tapGesture)
        promoView.roundCorners(corners: [.bottomRight, .topRight], radius: 20)
    }
    
    @objc func promoTappedView() {
        delegate?.didTapPromoView(in: self)
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return GrindOption.allCases.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return configureFilterPrice(for: indexPath)
        case 1:
            return configureFilterGrinds(for: indexPath)
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func configureFilterPrice(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionFilter.dequeueReusableCell(withReuseIdentifier: "FilterPriceCollectionCell", for: indexPath) as! FilterPriceCollectionCell
        return cell
    }
    
    func configureFilterGrinds(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionFilter.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let data = GrindOption.init(rawValue: indexPath.row)
        cell.configureContent(data?.description ?? "", isSelected: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // method delegate method untuk size item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let itemWidth = collectionView.bounds.width / 7
            return CGSize(width: itemWidth, height: 30)
        case 1:
            let itemWidth = collectionView.bounds.width / 2
            return CGSize(width: itemWidth, height: 40)
        default:
            return CGSize()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            didTapFilterPrice()
        case 1:
            setSelect(index: indexPath.item)
        default:
            break
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            setSelect(index: indexPath.item)
        default:
            break
        }
        
    }
    
    func setSelect(index: Int) {
        let selectedRawValue = GrindOption(rawValue: index)?.description ?? ""
        
        if selectedGrindOptions.contains(selectedRawValue) {
            selectedGrindOptions.removeAll { $0 == selectedRawValue}
        } else {
            selectedGrindOptions.append(selectedRawValue)
        }
        delegate?.didSelectGrindOption(Array(selectedGrindOptions))
    }
    
    func didTapFilterPrice() {
        delegate?.didFilterPrice()
    }
}

extension CategoryTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: CategoryCollectionViewCell.self)
    }
}


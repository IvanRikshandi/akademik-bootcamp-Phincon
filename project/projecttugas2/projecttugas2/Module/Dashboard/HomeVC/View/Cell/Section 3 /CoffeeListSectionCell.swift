import UIKit

protocol CoffeeListSectionCellDelegate: AnyObject {
    func didSelectItem(item: CoffeeModelElement)
}

class CoffeeListSectionCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    
    weak var delegate: CoffeeListSectionCellDelegate?
    let itemKey: String = "item_list"
    let layout = UICollectionViewFlowLayout()
    
    var filteredCoffees: [CoffeeModelElement] = [] {
        didSet {
            updateCollectionViewHeight()
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellWithNib(ContentCollectionViewCell.self)
    }
    
    func updateCollectionViewHeight() {
        heightCollectionView.constant = collectionView.contentSize.height
    }
}

extension CoffeeListSectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCoffees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as! ContentCollectionViewCell
        let data = filteredCoffees[indexPath.row]
        cell.configureContent(data: data)
        return cell
    }
    
    // method delegate method untuk size item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout , sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridWidth = collectionView.bounds.width
        let itemWidth = (gridWidth / 2 ) - 30
        return CGSize(width: itemWidth, height: 185)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(item: filteredCoffees[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
}

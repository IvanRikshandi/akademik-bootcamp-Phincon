import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class TabelViewDashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var welcomeNameLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    private let bag = DisposeBag()
    let coffeeAd = CoffeeAd.data
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
        setupCollection()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with userId: String) {
        Firebase.fetchUserData(userID: userId) { result in
            switch result {
            case .success(let document):
                if document.exists {
                    let data = document.data()
                    if let name = data?["nickName"] as? String {
                        self.welcomeNameLbl.text = String(format: .localized("welcome"), name)
                    }
                }
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }

    
    func setupCollection() {
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.registerCellWithNib(CarouselCell.self)
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
    }
    
    func setupStyle() {
        updateClock()
        containerView.roundCorners(corners: .allCorners, radius: 20)
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.masksToBounds = false
    }

    func updateClock() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).map {
            _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: Date())
        }
        .bind(to: dateLbl.rx.text)
        .disposed(by: bag)
    }
    
    @objc func scrollToNext() {
        guard let currentIndexPath = carouselCollectionView.indexPathsForVisibleItems.first else { return }
        
        let nextIndexPath: IndexPath
        
        if currentIndexPath.item + 1 < coffeeAd.count {
            nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
        } else {
            nextIndexPath = IndexPath(item: 0, section: currentIndexPath.section)
        }
        
        carouselCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
}

extension TabelViewDashboardTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coffeeAd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        let data = coffeeAd[indexPath.item]
        
        if let url = URL(string: data.imgUrl) {
            cell.imageAd.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}



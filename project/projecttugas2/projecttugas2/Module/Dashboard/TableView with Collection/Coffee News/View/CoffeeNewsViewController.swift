import UIKit
import RxSwift
import SkeletonView

class CoffeeNewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    
    let viewModel = CoffeeNewsViewModel()
    let bag = DisposeBag()
    
    var newsArticle: NewsCoffeeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        newsTableView.showAnimatedSkeleton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setup() {
        setupTableView()
        navigationController?.isNavigationBarHidden = true
        bindData()
    }
    
    func setupTableView() {
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.automaticallyAdjustsScrollIndicatorInsets = false
        newsTableView.registerCellWithNib(HeaderTableViewCell.self)
        newsTableView.registerCellWithNib(NewsContentTableViewCell.self)
        
        let paddingBottom: CGFloat = 50.0
        let paddingView = UIView(frame:  CGRect(x: 0, y: 0, width: newsTableView.bounds.width, height: paddingBottom))
        newsTableView.tableFooterView = paddingView
    }
    
    func bindData() {
        viewModel.fetchNews()
        
        viewModel.loadingState
            .asObservable()
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                switch loading {
                case .loading:
                    self.newsTableView.showAnimatedSkeleton()
                    print("loading")
                case .finished:
                    self.newsTableView.hideSkeleton()
                    DispatchQueue.main.async {
                        self.newsTableView.reloadData()
                    }
                case .failure:
                    self.newsTableView.hideSkeleton()
                }
            
            }).disposed(by: bag)
        
        viewModel.newsArticle.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            if let data = data {
                self.newsArticle = data
            }
        }).disposed(by: bag)
    }
}

extension CoffeeNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return newsArticle?.articles.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.bounces = false
        switch indexPath.section {
        case 0:
            return configureHeaderCell(for: indexPath)
        case 1:
            return configureNewsContent(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let selectedItem = newsArticle?.articles[indexPath.row]
            if let selectedItemUrl = selectedItem?.url{
                if let urlData = URL(string: selectedItemUrl) {
                    //UIApplication.shared.open(urlData, options: [:], completionHandler: nil)
                    let vc = DetailWebKit()
                    vc.selectedUrl = urlData
                    navigationController?.isNavigationBarHidden = false
                    navigationController?.hidesBarsOnSwipe = true
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func configureHeaderCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(forIndexPath: indexPath) as HeaderTableViewCell
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func configureNewsContent(for indexPath: IndexPath) -> UITableViewCell {
        
        let cell = newsTableView.dequeueReusableCell(forIndexPath: indexPath) as NewsContentTableViewCell
        if let list = newsArticle?.articles[indexPath.row] {
            cell.configureContent(data: list)
        }
        cell.backgroundColor = UIColor.clear
                
        return cell
    }
    
}

extension CoffeeNewsViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        String(describing: NewsContentTableViewCell.self)
    }
}

import UIKit
import Reachability
import RxSwift
import SkeletonView

class CoffeeNewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    let viewModel = CoffeeNewsViewModel()
    let bag = DisposeBag()
    var errorController: ErrorHandlingController?
    var newsArticle: NewsCoffeeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        newsTableView.showAnimatedSkeleton()
        errorController = ErrorHandlingController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Configuration
    
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
    
    // MARK: - Bind Data
    func bindData() {
        viewModel.fetchNews()
        
        viewModel.loadingState
            .asObservable()
            .subscribe(onNext: { [weak self] loading in
                guard let self = self else { return }
                switch loading {
                case .loading:
                    self.newsTableView.showAnimatedSkeleton()
                case .finished:
                    self.newsTableView.hideSkeleton()
                    DispatchQueue.main.async {
                        self.newsTableView.reloadData()
                    }
                case .failure:
                    self.newsTableView.hideSkeleton()
                    if !self.isConnected() {
                        ToastManager.shared.showToastOnlyMessage(message: "Please check your internet connection.")
                        self.showErrorView()
                    }
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

// MARK: - Configure Table
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
                    let viewController = DetailWebKit()
                    viewController.selectedUrl = urlData
                    navigationController?.isNavigationBarHidden = false
                    navigationController?.hidesBarsOnSwipe = true
                    navigationController?.pushViewController(viewController, animated: true)
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

// MARK: - Skeleton

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

// MARK: - Error Handling
extension CoffeeNewsViewController: ErrorHandlingDelegate {
    func showErrorView() {
        guard let errorController = errorController else { return }
        
        if !isConnected() {
            errorController.errorType = .networkError
        } else {
            errorController.errorType = .emptyDataError
        }
        errorController.delegate = self
        addChild(errorController)
        view.addSubview(errorController.view)
        errorController.didMove(toParent: self)
    }
    
    func didRefresh() {
        viewModel.fetchNews()
        refreshControl.endRefreshing()
    }
    
    func isConnected() -> Bool {
        guard let reachability = try? Reachability() else { return false }
        return reachability.connection != .unavailable
    }
}

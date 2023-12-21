import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import Reachability

class DashboardTabelViewController: UIViewController {
    
    @IBOutlet weak var listTabelView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var viewModel: DashboardViewModel!
    private let disposeBag = DisposeBag()
    private var errorVC: ErrorHandlingController?
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.backgroundColor = .systemPink
        let image = UIImage(systemName: "building.2.crop.circle.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        navigationController?.isNavigationBarHidden = true
        listTabelView.showSkeleton()
        bindViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DashboardViewModel()
        configureView()
        setupBackgroundImg()
        errorVC = ErrorHandlingController()
        view.addSubview(floatingButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        floatingButton.frame = CGRect(
            x: view.frame.size.width - 70, y: view.frame.size.height - 200, width: 60, height: 60)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DashboardTabelViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.bounces = false
        switch indexPath.section {
        case 0:
            return configureDashboardCell(for: indexPath)
        case 1:
            return configureCategoryCell(for: indexPath)
        case 2:
            return configureContentCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
}

// MARK: - CoffeeListSectionCellDelegate
extension DashboardTabelViewController: CoffeeListSectionCellDelegate {
    func didSelectItem(item: CoffeeModelElement) {
        navigateToDetailViewController(item)
    }
}

// MARK: - CategoryTableViewCellDelegate

extension DashboardTabelViewController: CategoryTableViewCellDelegate {
    
    func didFilterPrice() {
        showFilterPrice()
    }
    
    func didTapPromoView(in Cell: CategoryTableViewCell) {
        let vc = PromotionViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectGrindOption(_ grindOptions: [String]) {
        viewModel.filterByGrindOptions(selectedGrindOptions: grindOptions)
    }
}

extension DashboardTabelViewController: FilterDataDelegate {
    func didReset() {
        viewModel.loadData()
    }
    
    func didFilterPrice(minPrice: Double, maxPrice: Double) {
        viewModel.filterByPrice(minPrice: minPrice, maxPrice: maxPrice)
    }
}

// MARK: - Private Methods

extension DashboardTabelViewController: ErrorHandlingDelegate {
    
    private func setupBackgroundImg() {
        let backgroundImage = UIImage(named: "1332")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        self.listTabelView.backgroundView = backgroundImageView
        backgroundImageView.alpha = 0.1
        
        if let tabbar = self.tabBarController?.tabBar {
            tabbar.barTintColor = self.view.backgroundColor
        }
    }
    
    private func configureView() {
        listTabelView.automaticallyAdjustsScrollIndicatorInsets = false
        listTabelView.delegate = self
        listTabelView.dataSource = self
        listTabelView.registerCellWithNib(TabelViewDashboardTableViewCell.self)
        listTabelView.registerCellWithNib(CoffeeListSectionCell.self)
        listTabelView.registerCellWithNib(CategoryTableViewCell.self)
        listTabelView.contentInsetAdjustmentBehavior = .never
        
        let paddingBottom: CGFloat = 100.0 // Adjust the value as needed
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: listTabelView.bounds.width, height: paddingBottom))
        listTabelView.tableFooterView = paddingView
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        floatingButton.addTarget(self, action: #selector(toOutlet), for: .touchUpInside)
        floatingButton.addGestureRecognizer(panGesture)
    }
    
    private func bindViewModel() {
        viewModel.loadingState.asObservable().subscribe(
            onNext: { [weak self] state in
                switch state {
                case .loading:
                    self?.listTabelView.showSkeleton()
                case .finished:
                    self?.listTabelView.hideSkeleton()
                    self?.listTabelView.reloadData()
                case .failure:
                    self?.listTabelView.hideSkeleton()
                    if !(self?.isConnected() ?? false)  {
                        self?.showToast(isCheck: true)
                        self?.showErrorView()
                    }
                }
            })
        .disposed(by: disposeBag)
        
        viewModel.onDataLoaded = { [weak self] in
            self?.listTabelView.reloadData()
        }
    }
    
// MARK: - Error Handling Connection
    
    func showErrorView() {
        guard let errorVC = errorVC else { return }
        
        if !isConnected() {
            errorVC.errorType = .networkError
        } else {
            errorVC.errorType = .emptyDataError
        }
        errorVC.delegate = self
        addChild(errorVC)
        view.addSubview(errorVC.view)
        errorVC.didMove(toParent: self)
    }
    
    func didRefresh() {
        viewModel.loadData()
        refreshControl.endRefreshing()
    }
    
    func isConnected() -> Bool {
        guard let reachability = try? Reachability() else { return false }
        return reachability.connection != .unavailable
        
    }
    
// MARK: - Configure Cell
    func configureDashboardCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = listTabelView.dequeueReusableCell(forIndexPath: indexPath) as TabelViewDashboardTableViewCell
        cell.backgroundColor = UIColor.clear
        if let uid = Firebase.auth.currentUser?.uid {
            cell.configureCell(with: uid)
        }
        return cell
    }
    
    func configureCategoryCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = listTabelView.dequeueReusableCell(forIndexPath: indexPath) as CategoryTableViewCell
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func configureContentCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = listTabelView.dequeueReusableCell(forIndexPath: indexPath) as CoffeeListSectionCell
        cell.delegate = self
        cell.backgroundColor = UIColor.clear
        cell.filteredCoffees = viewModel.filteredCoffees
        cell.layoutIfNeeded()
        cell.heightCollectionView.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
        return cell
    }
    
    func navigateToDetailViewController(_ selectedDataItem: CoffeeModelElement) {
        let detailViewController = DetailCoffeeViewController()
        detailViewController.selectedData = selectedDataItem
        detailViewController.hidesBottomBarWhenPushed = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func showToast(isCheck: Bool) {
        let message = isCheck ? "Failed to fetch data. Please check your internet connection and try again." : "Success"
        ToastManager.shared.showToastOnlyMessage(message: message)
    }
    
    func showFilterPrice() {
        let filterVc = FilterPriceViewController()
        filterVc.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
        filterVc.delegate = self
        
        if let tabBarController = tabBarController {
            tabBarController.view.addSubview(filterVc.view)
            tabBarController.addChild(filterVc)
            filterVc.didMove(toParent: tabBarController)
        }
        
        UIView.animate(withDuration: 0.3) {
            filterVc.view.frame.origin.x += filterVc.view.frame.width
        }
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(toSwipe))
        swipeGesture.direction = .left
        filterVc.view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func toSwipe() {
        if let filterVc = tabBarController?.children.first(where: {$0 is FilterPriceViewController}) as? FilterPriceViewController {
            UIView.animate(withDuration: 0.3, animations: {
                filterVc.view.frame.origin.x -= filterVc.view.frame.width
            }) { (_) in
                filterVc.view.removeFromSuperview()
                filterVc.removeFromParent()
            }
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        floatingButton.center = CGPoint(x: floatingButton.center.x + translation.x, y: floatingButton.center.y + translation.y)
        
        gesture.setTranslation(CGPoint.zero, in: view)
    }
    
    @objc func toOutlet() {
        let vc = CoffeeOutletController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Skeleton View

extension DashboardTabelViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 3
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return String(describing: TabelViewDashboardTableViewCell.self)
        case 1:
            return String(describing: CategoryTableViewCell.self)
        case 2:
            return String(describing: CoffeeListSectionCell.self)
        default:
            return ""
        }
    }
}

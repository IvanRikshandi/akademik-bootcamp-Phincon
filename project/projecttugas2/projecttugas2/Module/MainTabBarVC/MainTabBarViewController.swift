import UIKit

class MainTabBarViewController: UITabBarController {
    
    let homeVC = UINavigationController(rootViewController: DashboardTabelViewController())
    let cartVC = UINavigationController(rootViewController: CartViewController())
    let newsVC = UINavigationController(rootViewController: CoffeeNewsViewController())
    let profileVC = UINavigationController(rootViewController: ProfileViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
        configureUITabbarItems()
        self.tabBar.backgroundColor = UIColor.white
    }
    
    func configureUITabbarItems(){
        homeVC.tabBarItem = UITabBarItem(title: .localized("dashboard"), image: SFSymbols.homeSymbol,  tag: 0)
        cartVC.tabBarItem = UITabBarItem(title: .localized("cart"), image: SFSymbols.orderSymbol,  tag: 1)
        newsVC.tabBarItem = UITabBarItem(title: .localized("news"), image: SFSymbols.newsSymbol, tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: .localized("profile"), image: SFSymbols.profileSymbol,  tag: 3)
        
        tabBar.tintColor = .brown
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.brown], for: .selected)
        
    }
    func configureTabBar(){
        homeVC.isNavigationBarHidden = true
        cartVC.isNavigationBarHidden = true
        setViewControllers([homeVC, cartVC, newsVC, profileVC], animated: true)
        
    }

}

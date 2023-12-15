//
//  MainTabBarViewController.swift
//  projecttugas2
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    let homeVc = UINavigationController(rootViewController: DashboardTabelViewController())
    let cart = UINavigationController(rootViewController: CartViewController())
    let news = UINavigationController(rootViewController: CoffeeNewsViewController())
    let profile = UINavigationController(rootViewController: ProfileViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
        configureUITabbarItems()
        self.tabBar.backgroundColor = UIColor.white
    }
    
    func configureUITabbarItems(){
        homeVc.tabBarItem = UITabBarItem(title: .localized("dashboard"), image: SFSymbols.homeSymbol,  tag: 0)
        cart.tabBarItem = UITabBarItem(title: .localized("cart"), image: SFSymbols.orderSymbol,  tag: 1)
        news.tabBarItem = UITabBarItem(title: .localized("news"), image: SFSymbols.newsSymbol, tag: 2)
        profile.tabBarItem = UITabBarItem(title: .localized("profile"), image: SFSymbols.profileSymbol,  tag: 3)
        
        tabBar.tintColor = .brown
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.brown], for: .selected)
        
    }
    func configureTabBar(){
        homeVc.isNavigationBarHidden = true
        cart.isNavigationBarHidden = true
        setViewControllers([homeVc, cart, news, profile], animated: true)
        
    }

}

//
//  SceneDelegate.swift
//  projecttugas2
//
//  Created by Phincon on 26/10/23.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func getUserLoggedIn() -> Bool{
        return BaseConstant.userDefaults.bool(forKey: "isLogin")
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarViewController = MainTabBarViewController()
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        if Firebase.currentUser != nil {
            navigationController.setViewControllers([tabBarViewController], animated: true)
        }
        
        navigationController.isNavigationBarHidden = true
        
        DispatchQueue.main.async {
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}


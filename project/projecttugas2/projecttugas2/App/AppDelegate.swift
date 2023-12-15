
import UIKit
import CoreData
import FirebaseCore
import FirebaseFirestore
import netfox
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Thread.sleep(forTimeInterval: 3)
        NFX.sharedInstance().start()
        
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 10
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 100
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}


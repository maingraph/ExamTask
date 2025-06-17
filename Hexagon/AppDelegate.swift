import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // iOS 13+ — ничего не меняем здесь
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
         configurationForConnecting connectingSceneSession: UISceneSession,
         options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

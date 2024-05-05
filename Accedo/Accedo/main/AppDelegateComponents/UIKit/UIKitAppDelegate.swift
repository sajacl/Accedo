import Foundation
import UIKit

final class UIKitAppDelegate: AppDelegateType {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let _window = UIWindow()

        _window.rootViewController = createMainViewController()
        _window.makeKeyAndVisible()

        window = _window

        return true
    }

    private func createMainViewController() -> UIViewController {
        GenreViewController()
    }
}

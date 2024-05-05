import Foundation
import UIKit

typealias AppDelegateType = UIResponder & UIApplicationDelegate

// Uncomment next line if you want to visit `UIKit` representation.
@UIApplicationMain
final class AppDelegate: AppDelegateType {
    let appDelegate = AppDelegateFactory.default()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let didFinish = appDelegate.application?(application, didFinishLaunchingWithOptions: launchOptions) {
            return didFinish
        }

        preconditionFailure(
            "One or many application configuration(s) was failed to launch sequence successfully."
        )
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        _ = appDelegate.applicationWillEnterForeground?(application)
    }
}

import Foundation
import UIKit

typealias AppDelegateType = UIResponder & UIApplicationDelegate

final class AppDelegate: AppDelegateType {
    let appDelegate = AppDelegateFactory.default()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        _ = appDelegate.application?(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        _ = appDelegate.application?(application, open: url, options: options)
        return true
    }

    func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        appDelegate.application?(
            application,
            performActionFor: shortcutItem,
            completionHandler: completionHandler
        )
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        _ = appDelegate.applicationWillEnterForeground?(application)
    }
}

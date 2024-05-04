import Foundation
import UIKit

final class CompositeAppDelegate: AppDelegateType {
    private let appDelegates: [AppDelegateType]

    init(appDelegates: [AppDelegateType]) {
        self.appDelegates = appDelegates
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        appDelegates.forEach {
            _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        appDelegates.forEach { _ = $0.application?(app, open: url, options: options) }
        return true
    }

    func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        appDelegates.forEach {
            $0.application?(
                application,
                performActionFor: shortcutItem,
                completionHandler: completionHandler
            )
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        appDelegates.forEach { $0.applicationWillEnterForeground?(application) }
    }
}

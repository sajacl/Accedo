import Foundation

enum AppDelegateFactory {
    static func `default`() -> AppDelegateType {
        CompositeAppDelegate(
            appDelegates: [UIKitAppDelegate(), SwiftUIAppDelegate()]
        )
    }
}

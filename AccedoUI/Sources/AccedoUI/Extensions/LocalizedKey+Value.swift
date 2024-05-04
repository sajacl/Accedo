import Foundation
import SwiftUI

extension LocalizedKey {
    fileprivate var key: String {
        switch self {
            case .appTitle:
                return "ApplicationTitle"
        }
    }
}

// MARK: SwiftUI
@available(iOS 13.0, *)
extension LocalizedKey {
    var stringKey: LocalizedStringKey {
        LocalizedStringKey(key)
    }
}

// MARK: UIKit
extension LocalizedKey {
    var text: String {
        NSLocalizedString(key, bundle: .module, value: "", comment: "")
    }
}

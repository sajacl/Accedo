import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct TextAtom: View {
        /// Initializes a `TextAtom` with a localization key.
        /// Used for static texts.
        /// - Parameters:
        ///   - key: The localization key for the text to be displayed.
        public init(_ key: LocalizedKey) {
            body = Text(key.stringKey, bundle: .module)
        }

        /// Initializes a `TextAtom` with a localization key.
        /// Used for dynamic texts.
        /// - Parameters:
        ///   - key: The localization key for the text to be displayed.
        public init(_ _text: String) {
            body = Text(_text)
        }

        /// The `Text` view to be displayed.
        public let body: Text
    }
}

@available(iOS 13.0, *)
#Preview {
    SU.SUIconAtom(.appTitleIcon)
}

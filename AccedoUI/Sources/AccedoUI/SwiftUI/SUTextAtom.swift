import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct TextAtom: View {
        /// The `Text` view to be displayed.
        private let text: Text

        /// Initializes a `TextAtom` with a localization key.
        /// - Parameters:
        ///   - key: The localization key for the text to be displayed.
        public init(
            _ key: LocalizedKey
        ) {
            text = Text(key.stringKey, bundle: .module)
        }

        public var body: some View {
            text
        }
    }
}

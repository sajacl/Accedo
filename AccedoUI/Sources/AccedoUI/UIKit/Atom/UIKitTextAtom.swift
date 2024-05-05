import Foundation
import class UIKit.UILabel

extension NS {
    public final class TextAtom: UILabel {
        public init(_ key: LocalizedKey, isUsingAutoLayout: Bool = false) {
            super.init(frame: .zero)

            text = key.text

            translatesAutoresizingMaskIntoConstraints = !isUsingAutoLayout
        }

        public init(isUsingAutoLayout: Bool = false) {
            super.init(frame: .zero)

            translatesAutoresizingMaskIntoConstraints = !isUsingAutoLayout
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }
}

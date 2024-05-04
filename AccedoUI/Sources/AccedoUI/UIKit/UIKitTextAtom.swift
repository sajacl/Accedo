import Foundation
import class UIKit.UILabel

extension NS {
    public final class TextAtom: UILabel {
        public init(_ key: LocalizedKey) {
            super.init(frame: .zero)

            text = key.text
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }
}

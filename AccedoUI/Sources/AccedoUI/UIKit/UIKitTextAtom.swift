import Foundation
import UIKit

extension NS {
    public final class TextAtom: UILabel {
        public init(_ key: LocalizedKey) {
            super.init(frame: .zero)

            text = key.text
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }
}

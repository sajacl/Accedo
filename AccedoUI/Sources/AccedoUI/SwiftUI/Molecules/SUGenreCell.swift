import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct SUGenreCell: View {
        /// Genre title.
        let title: String

        public init(title: String) {
            self.title = title
        }

        public var body: some View {
            TextAtom(title)
        }
    }
}

@available(iOS 13.0, *)
#Preview {
    SU.SUGenreCell(title: "Action")
}

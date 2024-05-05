import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct GenreCell: View {
        /// Genre title.
        let title: String

        /// Cell display style.
        @Environment(\.cellStyle) private var style

        public init(title: String) {
            self.title = title
        }

        public var body: some View {
            let configuration = SUCellStyleConfiguration(
                label: {
                    TextAtom(title)
                }
            )

            style.makeBody(configuration: configuration)
        }
    }
}

@available(iOS 13.0, *)
#Preview {
    SU.GenreCell(title: "Action")
}

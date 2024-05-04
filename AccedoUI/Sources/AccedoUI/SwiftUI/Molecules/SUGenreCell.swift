import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct GenreCell<Style: SUCellStyle>: View {
        /// Genre title.
        let title: String

        /// Cell display style.
        let style: Style

        public init(title: String, cellStyle: Style = SU.DefaultCellStyle()) {
            self.title = title
            self.style = cellStyle
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

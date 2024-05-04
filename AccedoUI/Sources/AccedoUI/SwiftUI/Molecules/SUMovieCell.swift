import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct MovieCell<Style: SUCellStyle>: View {
        /// Movie name.
        let name: String
        
        /// Movie image url.
        let imageURL: URL?
        
        /// Cell display style.
        let style: Style

        public init(name: String, imageURL: URL?, cellStyle: Style = SU.DefaultCellStyle()) {
            self.name = name
            self.imageURL = imageURL
            self.style = cellStyle
        }

        public var body: some View {
            let configuration = SUCellStyleConfiguration(
                label: {
                    TextAtom(name)
                },
                image: {
                    Image("icon_ApplicationTitle")
                }
            )

            style.makeBody(configuration: configuration)
        }
    }
}

@available(iOS 13.0, *)
#Preview {
    SU.MovieCell(
        name: "Batman",
        imageURL: URL(string: "www.google.com"),
        cellStyle: SU.CellListStyle()
    )
}

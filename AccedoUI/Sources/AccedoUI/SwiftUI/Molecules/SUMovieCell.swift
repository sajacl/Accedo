import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct MovieCell: View {
        /// Movie name.
        let name: String
        
        /// Movie image url.
        let imageURL: URL?

        /// Cell display style.
        @Environment(\.cellStyle) private var style

        public init(name: String, imageURL: URL?) {
            self.name = name
            self.imageURL = imageURL
        }

        public var body: some View {
            let configuration = SUCellStyleConfiguration(
                label: {
                    TextAtom(name)
                },
                image: {
                    IconAtom(.appTitleIcon, renderingMode: .original)
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
        imageURL: URL(string: "www.google.com")
    )
}

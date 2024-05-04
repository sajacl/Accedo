import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct SUMovieCell: View {
        /// Movie name.
        let name: String
        
        /// Movie image url.
        let imageURL: URL?

        public init(name: String, imageURL: URL?) {
            self.name = name
            self.imageURL = imageURL
        }

        public var body: some View {
            HStack {
                
            }
        }
    }
}

@available(iOS 13.0, *)
#Preview {
    SU.SUMovieCell(name: "Batman", imageURL: URL(string: "www.google.com"))
}

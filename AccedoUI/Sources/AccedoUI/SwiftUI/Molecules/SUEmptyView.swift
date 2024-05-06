import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct EmptyView: View {
        let emptyMessage: LocalizedStringKey
        let emptyImageSystemName: String

        public init(
            emptyMessage: LocalizedStringKey = "Empty list, come back later!",
            emptyImageSystemName: String = "figure"
        ) {
            self.emptyMessage = emptyMessage
            self.emptyImageSystemName = emptyImageSystemName
        }

        public var body: some View {
            if #available(iOS 17.0, *) {
                ContentUnavailableView(emptyMessage, systemImage: emptyImageSystemName)
            } else {
                VStack {
                    TextAtom(emptyMessage)

                    Image(systemName: emptyImageSystemName)
                }
            }
        }
    }
}

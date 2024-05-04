import Foundation
import SwiftUI

@available(iOS 13.0, *)
struct SUCellStyleConfiguration {
    /// A type-erased label of a cell.
    struct Label: View {
        init<Content: View>(content: Content) {
            body = AnyView(content)
        }

        let body: AnyView
    }

    /// A type-erased image of a cell.
    struct Image: View {
        init<Content: View>(content: Content) {
            body = AnyView(content)
        }

        let body: AnyView
    }

    let label: CellStyleConfiguration.Label

    let image: CellStyleConfiguration.Image?
}

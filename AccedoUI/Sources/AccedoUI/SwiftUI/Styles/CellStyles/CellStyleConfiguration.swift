import Foundation
import SwiftUI

@available(iOS 13.0, *)
public struct SUCellStyleConfiguration {
    /// A type-erased label of a cell.
    public struct Label: View {
        public init<Content: View>(content: () -> Content) {
            body = AnyView(content())
        }

        public let body: AnyView
    }

    /// A type-erased image of a cell.
    public struct Image: View {
        public init<Content: View>(content: () -> Content) {
            body = AnyView(content())
        }

        public let body: AnyView
    }

    let label: SUCellStyleConfiguration.Label

    let image: SUCellStyleConfiguration.Image?

    public init(@ViewBuilder label: () -> some View) {
        self.label = SUCellStyleConfiguration.Label(content: label)
        self.image = nil
    }

    public init(@ViewBuilder label: () -> some View, @ViewBuilder image: (() -> some View)) {
        self.label = SUCellStyleConfiguration.Label(content: label)
        self.image = SUCellStyleConfiguration.Image(content: image)
    }
}

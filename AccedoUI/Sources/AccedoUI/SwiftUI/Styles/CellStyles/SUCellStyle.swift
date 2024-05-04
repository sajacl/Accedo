import SwiftUI

@available(iOS 13.0, *)
public protocol SUCellStyle {
    associatedtype Body: View
    typealias Configuration = SUCellStyleConfiguration

    func makeBody(configuration: Self.Configuration) -> Self.Body
}

@available(iOS 13.0, *)
struct DefaultCardStyle: SUCellStyle {
    func makeBody(configuration: Configuration) -> some View {
        #if os(iOS)
            return SU.CellListStyle().makeBody(configuration: configuration)
        #else
            return SU.CellGridStyle().makeBody(configuration: configuration)
        #endif
    }
}

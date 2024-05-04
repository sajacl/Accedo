import SwiftUI

@available(iOS 13.0, *)
public protocol SUCellStyle {
    associatedtype Body: View
    typealias Configuration = SUCellStyleConfiguration

    func makeBody(configuration: Self.Configuration) -> Self.Body
}

@available(iOS 13.0, *)
extension SU {
    public struct DefaultCellStyle: SUCellStyle {
        public init() {}
        
        public func makeBody(configuration: Configuration) -> some View {
            #if os(iOS)
                return SU.CellListStyle().makeBody(configuration: configuration)
            #else
                return SU.CellGridStyle().makeBody(configuration: configuration)
            #endif
        }
    }
}

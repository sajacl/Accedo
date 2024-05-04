import SwiftUI

@available(iOS 13.0, *)
protocol SUCellStyle {
    associatedtype Body: View
    typealias Configuration = SUCellStyleConfiguration

    func makeBody(configuration: Self.Configuration) -> Self.Body
}

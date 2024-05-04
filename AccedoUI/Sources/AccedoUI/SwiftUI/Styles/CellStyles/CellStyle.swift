import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct CellListStyle: SUCellStyle {
        public init() {}

        public func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration
                    .image
                    .frame(maxWidth: 60)

                configuration
                    .label
                    .multilineTextAlignment(.leading)
            }
            .frame(minHeight: 24)
            .frame(maxHeight: 60)
        }
    }
}

@available(iOS 13.0, *)
extension SU {
    public struct CellGridStyle: SUCellStyle {
        public init() {}
        
        public func makeBody(configuration: Configuration) -> some View {
            VStack {
                configuration
                    .image
                    .background(Color.yellow)

                configuration
                    .label
                    .multilineTextAlignment(.center)
                    .frame(height: 24)
                    .background(Color.blue)
            }
            .frame(minWidth: 60, minHeight: 60)
            .frame(maxWidth: 120, maxHeight: 120)
            .background(Color.red)
        }
    }
}

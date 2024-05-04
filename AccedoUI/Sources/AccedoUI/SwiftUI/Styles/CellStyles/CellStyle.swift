import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct CellListStyle: SUCellStyle {
        public func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.image.flatMap { image in
                    GeometryReader { proxy in
                        image
                            .frame(width: proxy.size.width / 4, height: proxy.size.height - 8)
                    }
                }
                
                configuration
                    .label
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

@available(iOS 13.0, *)
extension SU {
    public struct CellGridStyle: SUCellStyle {
        public func makeBody(configuration: Configuration) -> some View {
            VStack {
                configuration
                    .image
                    .flatMap { image in
                        GeometryReader { proxy in
                            image
                                .frame(width: proxy.size.width - 14)
                        }
                    }

                configuration
                    .label
                    .multilineTextAlignment(.center)
                    .frame(height: 24)
            }
        }
    }
}

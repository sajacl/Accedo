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

                configuration
                    .label
                    .multilineTextAlignment(.center)
                    .frame(height: 24)
            }
            .frame(width: 150, height: 150, alignment: .center)
            .background(Color.blue)
            .cornerRadius(10)
            .foregroundColor(.white)
            .font(.title)
        }
    }
}

@available(iOS 13.0, *)
extension SU {
    public struct DefaultCellStyle: SUCellStyle {
        private let userInterfaceIdiom: UIUserInterfaceIdiom

        public init(
            userInterfaceIdiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
        ) {
            self.userInterfaceIdiom = userInterfaceIdiom
        }

        @ViewBuilder
        public func makeBody(configuration: Configuration) -> some View {
            #if os(iOS)
                if userInterfaceIdiom == .phone {
                    SU.CellListStyle().makeBody(configuration: configuration)
                } else {
                    SU.CellGridStyle().makeBody(configuration: configuration)
                }
            #else
                SU.CellGridStyle().makeBody(configuration: configuration)
            #endif
        }
    }
}

@available(iOS 13.0, *)
extension SU {
    public struct AnyCellStyle: SUCellStyle {
        private var _makeBody: (Configuration) -> AnyView

        public init<Style: SUCellStyle>(style: Style) {
            _makeBody = { configuration in
                AnyView(style.makeBody(configuration: configuration))
            }
        }

        public func makeBody(configuration: Configuration) -> some View {
            _makeBody(configuration)
        }
    }
}

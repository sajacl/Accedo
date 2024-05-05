import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension SU {
    public struct CellStyleKey: EnvironmentKey {
        public static var defaultValue = AnyCellStyle(style: DefaultCellStyle())
    }
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    public var cellStyle: SU.AnyCellStyle {
        get { self[SU.CellStyleKey.self] }
        set { self[SU.CellStyleKey.self] = newValue }
    }
}

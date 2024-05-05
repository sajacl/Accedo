import Foundation
import struct SwiftUI.Binding

extension Binding where Value == (any Error)? {
    var isPresented: Binding<Bool> {
        Binding<Bool>(
            get: {
                wrappedValue != nil
            },
            set: { newValue in
                if !newValue {
                    wrappedValue = nil
                }
            }
        )
    }
}

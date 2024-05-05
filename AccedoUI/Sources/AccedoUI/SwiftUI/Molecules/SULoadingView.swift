import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
extension SU {
    public struct LoadingView: View {
        public var body: some View {
            if #available(iOS 14.0, *) {
                ProgressView()
            } else {
                ActivityIndicator(isAnimating: .constant(true), style: .large)
            }
        }
    }
}

@available(iOS 13.0, *)
private struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool

    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

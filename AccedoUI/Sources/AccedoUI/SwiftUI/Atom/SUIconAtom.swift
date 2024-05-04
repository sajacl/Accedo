import SwiftUI

@available(iOS 13.0, *)
extension SU {
    struct IconAtom: View {
        let icon: Icon
        let preferredSize: CGFloat?
        let renderingMode: Image.TemplateRenderingMode

        init(
            _ icon: Icon,
            preferredSize: CGFloat? = 24,
            renderingMode: Image.TemplateRenderingMode = .template
        ) {
            self.icon = icon
            self.preferredSize = preferredSize
            self.renderingMode = renderingMode
        }

        var body: some View {
            Image(icon.assetName, bundle: .module)
                .renderingMode(renderingMode)
                .resizable()
                .modifier(OptionalSizeModifier(preferredSize: preferredSize))
        }
    }

    struct OptionalSizeModifier: ViewModifier {
        let preferredSize: CGFloat?

        func body(content: Content) -> some View {
            if let size = preferredSize {
                content
                    .frame(width: size, height: size)
            }
        }
    }
}

@available(iOS 13.0, *)
#Preview {
    SU.IconAtom(.appTitleIcon)
}

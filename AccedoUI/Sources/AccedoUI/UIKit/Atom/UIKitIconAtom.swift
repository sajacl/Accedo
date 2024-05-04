import Foundation
import class UIKit.UIImageView
import class UIKit.UIImage
import class UIKit.NSLayoutConstraint

extension NS {
    public final class IconAtom: UIImageView {
        public init(
            _ icon: Icon,
            preferredSize: CGFloat? = 24,
            renderingMode: UIImage.RenderingMode = .alwaysTemplate
        ) {
            super.init(frame: .zero)
            
            let configurator = ImageViewConfigurator(
                icon: icon,
                preferredSize: preferredSize,
                renderingMode: renderingMode
            )

            configurator.configure(imageView: self)
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }

    struct ImageViewConfigurator {
        let icon: Icon
        let preferredSize: CGFloat?
        let renderingMode: UIImage.RenderingMode

        @inlinable
        func configure(imageView: UIImageView) {
            imageView.translatesAutoresizingMaskIntoConstraints = false

            if let preferredSize {
                let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: preferredSize)
                let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: preferredSize)

                NSLayoutConstraint.activate([widthConstraint, heightConstraint])
            }

            let _image = UIImage(named: icon.assetName)?.withRenderingMode(renderingMode)
            imageView.image = _image
        }
    }
}

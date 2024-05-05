import Foundation
import class UIKit.UIImageView
import class UIKit.UIImage
import class UIKit.NSLayoutConstraint

extension NS {
    public final class IconAtom: UIImageView {
        public init(
            _ icon: Icon,
            preferredSize: CGFloat? = 24,
            renderingMode: UIImage.RenderingMode = .alwaysTemplate,
            isUsingAutoLayout: Bool = false
        ) {
            super.init(frame: .zero)
            
            let configurator = ImageViewConfigurator(
                icon: icon,
                preferredSize: preferredSize,
                renderingMode: renderingMode,
                isUsingAutoLayout: isUsingAutoLayout
            )

            configurator.configure(imageView: self)
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }

    fileprivate struct ImageViewConfigurator {
        let icon: Icon
        let preferredSize: CGFloat?
        let renderingMode: UIImage.RenderingMode
        let isUsingAutoLayout: Bool

        @inlinable
        func configure(imageView: UIImageView) {
            imageView.translatesAutoresizingMaskIntoConstraints = !isUsingAutoLayout

            if let preferredSize {
                if isUsingAutoLayout {
                    let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: preferredSize)
                    let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: preferredSize)

                    NSLayoutConstraint.activate([widthConstraint, heightConstraint])
                } else {
                    imageView.frame = CGRect(
                        origin: .zero,
                        size: CGSize(width: preferredSize, height: preferredSize)
                    )
                }
            }

            let _image = UIImage(named: icon.assetName)?.withRenderingMode(renderingMode)
            imageView.image = _image
        }
    }
}

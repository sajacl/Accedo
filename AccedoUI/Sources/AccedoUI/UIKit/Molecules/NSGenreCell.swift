import Foundation
import UIKit

private let identifier = "CustomCollectionViewCell"

extension NS {
    public final class CollectionViewCell: UICollectionViewCell {
        private lazy var imageView: NS.IconAtom = {
            let imageView = NS.IconAtom(.appTitleIcon)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            return imageView
        }()

        private lazy var titleLabel: NS.TextAtom = {
            let label = NS.TextAtom()
            label.textAlignment = .center
            return label
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)

            configCell()
            addViews()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)

            configCell()

            addViews()
        }

        private func configCell() {
            contentView.clipsToBounds = true
        }

        private func addViews() {
            contentView.addSubview(imageView)
            contentView.addSubview(titleLabel)
        }

        public override func layoutSubviews() {
            super.layoutSubviews()

            imageView.frame = CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 50)
            titleLabel.frame = CGRect(x: 5, y: frame.size.height - 45, width: frame.size.width - 10, height: 40)
        }

        public func configure(title: String, imageURL: URL?) {
            titleLabel.text = title
        }
    }
}

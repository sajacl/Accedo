import Foundation
import UIKit
import AccedoUI

private let cellIdentifier = "CustomCollectionViewCell"

final class GenreViewController: UIViewController,
                                 UICollectionViewDelegate,
                                 UICollectionViewDataSource {
    private var isGridViewActive = true

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            NS.CollectionViewCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )

        collectionView.backgroundColor = .white

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Toggle View",
            style: .plain,
            target: self,
            action: #selector(toggleLayout)
        )
    }

    @objc private func toggleLayout() {
        isGridViewActive.toggle()

        collectionView.collectionViewLayout.invalidateLayout()

        collectionView.reloadData()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 20 // Arbitrary number of items
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? NS.CollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }

        cell.configure(title: "Item \(indexPath.row)", imageURL: nil)

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if isGridViewActive {
            let width = (view.frame.size.width/3) - 16
            
            return CGSize(width: width, height: width + 40)
        } else {
            return CGSize(width: view.frame.size.width - 20, height: 100)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
}

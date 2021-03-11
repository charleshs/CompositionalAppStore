//
//  AppStoreViewController.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/2/5.
//

import UIKit

final class AppStoreViewController: BaseViewController {
    private var sections: [Section] = [.gallery, .group3, .group3, .list]

    private lazy var collectionViewLayout: UICollectionViewLayout =
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            return self?.sections[sectionIndex].builder.layoutSection(for: environment)
        }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
        ])

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: .placeholderCell, bundle: nil), forCellWithReuseIdentifier: .placeholderCell)
        collectionView.register(UINib(nibName: .appStoreGalleryCell, bundle: nil), forCellWithReuseIdentifier: .appStoreGalleryCell)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .group3Header)
    }
}

extension AppStoreViewController {
    enum Section {
        case gallery
        case group3
        case list
        
        var builder: LayoutSectionBuildable {
            switch self {
            case .gallery:
                return GalleryPagedSection(itemWidthRatio: itemWidthRatio, groupWidthRatio: groupWidthRatio, verticalInsets: 12, contentHeight: 300)
            case .group3:
                return ClusterPagedSection(itemWidthRatio: itemWidthRatio, groupWidthRatio: groupWidthRatio, verticalInsets: 12, itemCount: 3, interItemSpacing: 8)
            case .list:
                return ListSection(itemWidthRatio: itemWidthRatio, groupWidthRatio: groupWidthRatio, verticalInsets: 12)
            }
        }

        private var itemWidthRatio: CGFloat { return 0.97 }
        private var groupWidthRatio: CGFloat { return 0.92 }
    }
}

extension AppStoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .gallery:
            return collectionView.dequeueReusableCell(withReuseIdentifier: .appStoreGalleryCell, for: indexPath)
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .placeholderCell, for: indexPath) as! PlaceholderCell
            cell.textLabel.text = "\(indexPath.section), \(indexPath.item)"
            cell.contentView.backgroundColor = .systemTeal
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .group3Header, for: indexPath)
        headerView.backgroundColor = .cyan
        return headerView
    }
}

private extension String {
    static let group3Header = "Group3Header"
    static let placeholderCell = "PlaceholderCell"
    static let appStoreGalleryCell = "AppStoreGalleryCell"
}

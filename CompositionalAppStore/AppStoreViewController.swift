//
//  AppStoreViewController.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/2/5.
//

import UIKit

final class AppStoreViewController: BaseViewController {
    private var sections: [Section] = [.gallery, .group3, .group3, .list]

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            return self?.sections[sectionIndex].layoutSection(for: environment)
        }
        return layout
    }()

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

        private var itemWidthRatio: CGFloat { return 0.97 }
        private var groupWidthRatio: CGFloat { return 0.92 }
        private var insetLeadingRatio: CGFloat {
            return 1 - (itemWidthRatio + groupWidthRatio) / 2
        }
        private var contentWidthRatio: CGFloat {
            return (itemWidthRatio + groupWidthRatio) / 2
        }

        func layoutSection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
            return buildSection(forGroup: buildGroup(), environment: environment)
        }

        private func buildGroup() -> NSCollectionLayoutGroup {
            let group: NSCollectionLayoutGroup
            switch self {
            case .gallery:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthRatio), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthRatio), heightDimension: .absolute(300))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            case .group3:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthRatio), heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthRatio), heightDimension: .absolute(300))
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
                group.interItemSpacing = .fixed(8)
            case .list:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(contentWidthRatio), heightDimension: .absolute(44))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            }
            return group
        }

        private func buildSection(forGroup group: NSCollectionLayoutGroup, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
            let contentWidth = environment.container.contentSize.width
            let section: NSCollectionLayoutSection
            switch self {
            case .gallery:
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
            case .group3:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top, absoluteOffset: CGPoint(x: 0, y: 0))
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [headerItem]
            case .list:
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
            }
            section.contentInsets = .init(top: 12, leading: contentWidth * insetLeadingRatio, bottom: 12, trailing: 0)
            return section
        }
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

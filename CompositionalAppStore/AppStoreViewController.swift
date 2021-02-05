//
//  AppStoreViewController.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/2/5.
//

import UIKit

final class AppStoreViewController: BaseViewController {
    private var sectionKinds: [LayoutSectionKind] = [.gallery, .group3, .group3, .list]

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            let layoutSection = self?.sectionKinds[sectionIndex].layoutSection()
            return layoutSection
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

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
}

extension AppStoreViewController {
    private enum LayoutSectionKind {
        case gallery
        case group3
        case list

        private static let itemWidthRatio: CGFloat = 0.97
        private static let groupWidthRatio: CGFloat = 0.92
        private static var insetLeadingRatio: CGFloat {
            return 1 - (itemWidthRatio + groupWidthRatio) / 2
        }
        private static var contentWidthRatio: CGFloat {
            return (itemWidthRatio + groupWidthRatio) / 2
        }

        func layoutSection() -> NSCollectionLayoutSection {
            return buildSection(forGroup: buildGroup())
        }

        private func buildGroup() -> NSCollectionLayoutGroup {
            let group: NSCollectionLayoutGroup
            switch self {
            case .gallery:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Self.itemWidthRatio), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Self.groupWidthRatio), heightDimension: .absolute(300))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            case .group3:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Self.itemWidthRatio), heightDimension: .estimated(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Self.groupWidthRatio), heightDimension: .absolute(300))
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
                group.interItemSpacing = .fixed(8)
            case .list:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Self.contentWidthRatio), heightDimension: .absolute(44))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            }
            return group
        }

        private func buildSection(forGroup group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
            let section: NSCollectionLayoutSection
            switch self {
            case .gallery, .group3:
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
            case .list:
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
            }
            section.contentInsets = .init(top: 12, leading: UIScreen.main.bounds.width * Self.insetLeadingRatio, bottom: 0, trailing: 0)
            return section
        }
    }
}

extension AppStoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionKinds.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = .systemTeal
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
        headerView.backgroundColor = .cyan
        return headerView
    }
}

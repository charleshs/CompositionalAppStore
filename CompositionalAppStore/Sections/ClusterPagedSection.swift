//
//  ClusterPagedSection.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/3/11.
//

import UIKit

public struct ClusterPagedSection: AppStoreLayoutSection {
    let itemWidthRatio: CGFloat
    let groupWidthRatio: CGFloat
    let verticalInsets: CGFloat
    let itemCount: Int
    let interItemSpacing: CGFloat

    public init(itemWidthRatio: CGFloat, groupWidthRatio: CGFloat, verticalInsets: CGFloat, itemCount: Int, interItemSpacing: CGFloat) {
        self.itemWidthRatio = itemWidthRatio
        self.groupWidthRatio = groupWidthRatio
        self.verticalInsets = verticalInsets
        self.itemCount = itemCount
        self.interItemSpacing = interItemSpacing
    }

    public func layoutSection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthRatio), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthRatio), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: itemCount)
        group.interItemSpacing = .fixed(interItemSpacing)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top,
                                                                     absoluteOffset: CGPoint(x: 0, y: 0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [headerItem]
        applyInsets(to: section, for: environment)
        return section
    }
}

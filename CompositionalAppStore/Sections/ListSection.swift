//
//  ListSection.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/3/11.
//

import UIKit

public struct ListSection: AppStoreLayoutSection {
    let itemWidthRatio: CGFloat
    let groupWidthRatio: CGFloat
    let verticalInsets: CGFloat

    public init(itemWidthRatio: CGFloat, groupWidthRatio: CGFloat, verticalInsets: CGFloat) {
        self.itemWidthRatio = itemWidthRatio
        self.groupWidthRatio = groupWidthRatio
        self.verticalInsets = verticalInsets
    }

    public func layoutSection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        applyInsets(to: section, for: environment)
        return section
    }
}

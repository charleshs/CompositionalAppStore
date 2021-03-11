//
//  GalleryPagedSection.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/3/11.
//

import UIKit

public struct GalleryPagedSection: AppStoreLayoutSection {
    let itemWidthRatio: CGFloat
    let groupWidthRatio: CGFloat
    let verticalInsets: CGFloat
    let contentHeight: CGFloat

    public init(itemWidthRatio: CGFloat, groupWidthRatio: CGFloat, verticalInsets: CGFloat, contentHeight: CGFloat) {
        self.itemWidthRatio = itemWidthRatio
        self.groupWidthRatio = groupWidthRatio
        self.verticalInsets = verticalInsets
        self.contentHeight = contentHeight
    }

    public func layoutSection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthRatio), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthRatio), heightDimension: .estimated(contentHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        applyInsets(to: section, for: environment)
        return section
    }
}

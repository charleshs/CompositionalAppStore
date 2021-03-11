//
//  PagedSection.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/3/11.
//

import UIKit

protocol LayoutSectionBuildable {
    func layoutSection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
}

protocol AppStoreLayoutSection: LayoutSectionBuildable {
    var itemWidthRatio: CGFloat { get }
    var groupWidthRatio: CGFloat { get }
    var verticalInsets: CGFloat { get }
}

extension AppStoreLayoutSection {
    public var insetLeadingRatio: CGFloat {
        return 1 - contentWidthRatio
    }

    public var contentWidthRatio: CGFloat {
        return (itemWidthRatio + groupWidthRatio) / 2
    }

    /// Applies content insets to a given section.
    public func applyInsets(to section: NSCollectionLayoutSection, for env: NSCollectionLayoutEnvironment) {
        let contentWidth = env.container.contentSize.width
        let horizontalInsets = contentWidth * insetLeadingRatio
        section.contentInsets = .init(top: verticalInsets, leading: horizontalInsets, bottom: verticalInsets, trailing: horizontalInsets)
    }
}

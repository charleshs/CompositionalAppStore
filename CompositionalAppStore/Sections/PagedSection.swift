//
//  PagedSection.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/3/11.
//

import UIKit

protocol SectionLayoutBuildable {
    func layoutSection(for environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection
}

protocol AppStoreLayoutSection: SectionLayoutBuildable {
    var itemWidthRatio: CGFloat { get }
    var groupWidthRatio: CGFloat { get }
    var verticalInsets: CGFloat { get }
}

extension AppStoreLayoutSection {
    public var insetLeadingRatio: CGFloat {
        return 1 - (itemWidthRatio + groupWidthRatio) / 2
    }
    
    public var contentWidthRatio: CGFloat {
        return (itemWidthRatio + groupWidthRatio) / 2
    }
    
    public func applyInsets(to section: NSCollectionLayoutSection, for env: NSCollectionLayoutEnvironment) {
        let contentWidth = env.container.contentSize.width
        let horizontalInsets = contentWidth * insetLeadingRatio
        section.contentInsets = .init(top: verticalInsets, leading: horizontalInsets, bottom: verticalInsets, trailing: horizontalInsets)
    }
}

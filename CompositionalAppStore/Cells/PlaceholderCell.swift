//
//  PlaceholderCell.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/2/5.
//

import UIKit

final class PlaceholderCell: UICollectionViewCell {
    @IBOutlet private(set) var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.cornerRadius = 8
    }
}

//
//  AppStoreGalleryCell.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/2/5.
//

import UIKit

final class AppStoreGalleryCell: UICollectionViewCell {
    @IBOutlet private(set) var categoryLabel: UILabel!
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var descriptionLabel: UILabel!
    @IBOutlet private(set) var appImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        appImageView.layer.cornerRadius = 8
    }
}

//
//  HeaderReusableView.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/3/11.
//

import UIKit

final class HeaderReusableView: UICollectionReusableView {
    var text: String? {
        get { return textLabel.text }
        set { textLabel.text = newValue }
    }

    private let textLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 8

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
            bottomAnchor.constraint(equalTo: textLabel.bottomAnchor),
        ])
    }
}

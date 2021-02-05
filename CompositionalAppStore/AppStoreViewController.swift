//
//  AppStoreViewController.swift
//  CompositionalAppStore
//
//  Created by Charles Hsieh on 2021/2/5.
//

import UIKit

final class AppStoreViewController: BaseViewController {
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let itemWidthRatio: CGFloat = 0.97
        let groupWidthRatio: CGFloat = 0.92
        let insetLeadingRatio: CGFloat = 1 - (itemWidthRatio + groupWidthRatio) / 2

        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemWidthRatio), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupWidthRatio), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: UIScreen.main.bounds.width * insetLeadingRatio, bottom: 0, trailing: 0)
        // Layout
        let layout = UICollectionViewCompositionalLayout(section: section)
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
    }
}

extension AppStoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = .systemTeal
        return cell
    }
}

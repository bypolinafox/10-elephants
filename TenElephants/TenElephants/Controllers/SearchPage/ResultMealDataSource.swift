//
//  ResultMealDataSource.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 13.12.2021.
//

import Foundation
import UIKit

final class ResultMealDataSource: NSObject, UICollectionViewDataSource {
    private let cellHeight: CGFloat
    private let sideInsetValue: CGFloat
    private let cellID: String
    private let imageFetcher: CachedImageFetcher

    let openMealPageController: (Meal) -> Void

    var meals = [Meal]()

    init(
        cellHeight: CGFloat,
        insetValue: CGFloat,
        cellID: String,
        imageFetcher: CachedImageFetcher,
        openSingleMeal: @escaping (Meal) -> Void
    ) {
        self.cellHeight = cellHeight
        self.sideInsetValue = insetValue
        self.cellID = cellID
        self.imageFetcher = imageFetcher
        self.openMealPageController = openSingleMeal
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        min(meals.count, 10) // can't be more than 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        guard let mealCell = cell as? WideCellView else { return cell }
        let meal = meals[indexPath.row]
        mealCell.titleLabel.text = meal.name
        mealCell.subtitleLabel.text = meal.id

        guard let url = meal.thumbnailLink.flatMap({ NSURL(string: $0) }) else { return mealCell }

        imageFetcher.fetch(url: url, completion: { image in
            mealCell.imageView.image = image
        })
        return mealCell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        openMealPageController(meal)
    }
}

extension ResultMealDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width - sideInsetValue * 2, height: cellHeight)
    }
}

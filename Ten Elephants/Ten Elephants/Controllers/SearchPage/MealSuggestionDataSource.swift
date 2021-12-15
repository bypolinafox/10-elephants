//
//  MealSuggestionDataSource.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 13.12.2021.
//

import Foundation
import UIKit

final class MealSuggestionDataSource: NSObject, UICollectionViewDataSource {
    private let cellWidth: CGFloat
    private let cellID: String
    private let imageFetcher: CachedImageFetcher
    
    let openMealPageController: (Meal) -> Void
    
    
    var meals = [Meal]()
    
    init(cellWidth: CGFloat,
         cellID: String,
         imageFetcher: CachedImageFetcher,
         openSingleMeal: @escaping (Meal) -> Void
    ){
        self.cellWidth = cellWidth
        self.cellID = cellID
        self.imageFetcher = imageFetcher
        self.openMealPageController = openSingleMeal
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        min(meals.count, 10) //can't be more than 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        guard let suggestionCell = cell as? WideCellView else { return cell }
        suggestionCell.clipsToBounds = false
        suggestionCell.layer.masksToBounds = false
        
        let meal = meals[indexPath.row]
        suggestionCell.titleLabel.text = meal.name
        suggestionCell.subtitleLabel.text = meal.id
        
        guard let url = meal.thumbnailLink.flatMap({ NSURL(string: $0) }) else { return suggestionCell }
        
        imageFetcher.fetch(url: url) { image in
            suggestionCell.imageView.image = image
        }

        return suggestionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        openMealPageController(meal)
    }
}

extension MealSuggestionDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}

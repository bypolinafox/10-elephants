//
//  ingredientDataSource.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 13.12.2021.
//

import Foundation
import UIKit

final class IngredientDataSource: NSObject, UICollectionViewDataSource {
    private enum Constants {
        static let edgeInsetValue: CGFloat = 10
    }

    private let cellID: String

    private let keys: [String]
    private let updateParentFilters: ([String]) -> Void

    private(set) var filters = Set<String>()

    init(cellID: String, updateParentFilters: @escaping ([String]) -> Void) {
        self.cellID = cellID
        self.keys = Array(ingredientSuggestions.keys)
        self.updateParentFilters = updateParentFilters
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        keys.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        guard let ingredientCell = cell as? IngredientSuggestionCell else { return cell }
        guard let ingredient = ingredientSuggestions[keys[indexPath.row]] else { return cell }
        ingredientCell.ingredientName.text = ingredient.fullName
        ingredientCell.isUserInteractionEnabled = true
        ingredientCell.setActiveState(isActive: filters.contains(keys[indexPath.row]))
        return ingredientCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ingredient = keys[indexPath.row]
        if filters.contains(ingredient) {
            filters.remove(ingredient)
        } else {
            filters.insert(ingredient)
        }
        DispatchQueue.main.async {
            collectionView.reloadItems(at: [indexPath])
            self.updateParentFilters(Array(self.filters))
        }
    }
}

extension IngredientDataSource: UICollectionViewDelegateFlowLayout {
    private func getCellTextWidth(_ s: String?) -> CGFloat {
        guard let s = s else { return 0 }
        let font = IngredientSuggestionCell.titleFont
        let attributes = [NSAttributedString.Key.font: font]
        let size = NSString(string: s).size(withAttributes: attributes)
        return size.width
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = getCellTextWidth(ingredientSuggestions[keys[indexPath.row]]?.fullName) +
            Constants.edgeInsetValue * 2
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}

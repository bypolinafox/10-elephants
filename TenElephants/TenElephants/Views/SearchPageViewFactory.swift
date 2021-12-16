//
//  SearchPageViewFactory.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 13.12.2021.
//

import Foundation
import UIKit

final class SearchPageViewFactory {
    private enum Constants {
        static let ingredientSuggestTitle = "Search by ingredient"
        static let searchBarPlaceHolder = "Meal, ingredient..."
        static let sideInsetValue: CGFloat = 16
        static let mealSuggestionBottomInsetValue: CGFloat = 10
        static let sideInsets = UIEdgeInsets(
            top: 0,
            left: sideInsetValue,
            bottom: 0,
            right: sideInsetValue
        )
        static let mealHeight: CGFloat = 250
        static let ingredientHeight: CGFloat = 50

        static let mealSuggestionCellWidth: CGFloat = 320
        static let sectionSpacing: CGFloat = 10
        static let titleSpacing: CGFloat = 5
        static let mealResultCellHeight: CGFloat = 300
        static let titleFontSize: CGFloat = 17

        static let blurAnimationDuration: TimeInterval = 0.5

        static let nothingFoundEmoji = "🔎"
        static let nothingFoundTitle = "Nothing found"
        static let nothingFoundDescription = "Please try again with a different request"
    }

    func makeSuggestionsScrollView() -> UIScrollView {
        UIScrollView()
    }

    func makeSuggestionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = Constants.sectionSpacing
        return stackView
    }

    func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.layoutMargins = Constants.sideInsets
        searchBar.placeholder = Constants.searchBarPlaceHolder
        return searchBar
    }

    func makeMealCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = Constants.sideInsets
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }

    func makeMealSuggestionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.titleSpacing
        return stackView
    }

    func makeMealSuggestionTitle() -> UILabel {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        title.textAlignment = .left
        return title
    }

    func makeIngredientSuggestionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.titleSpacing
        return stackView
    }

    func makeIngredientSuggestionTitle() -> UILabel {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        title.text = Constants.ingredientSuggestTitle
        title.textAlignment = .left
        return title
    }

    func makeIngredientCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = Constants.sideInsets
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }

    func makeResultCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = Constants.sideInsets
        cv.showsHorizontalScrollIndicator = false
        return cv
    }

    func makeBlurView() -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
    }

    func makeNothingFoundStack(
        emoji: String = Constants.nothingFoundEmoji,
        title: String = Constants.nothingFoundTitle,
        description: String = Constants.nothingFoundDescription
    ) -> UIStackView {
        NothingFoundStack(emoji: emoji, title: title, description: description)
    }
}

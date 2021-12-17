//
//  MealViewFactory.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 10.12.2021.
//

import UIKit

final class MealViewFactory {
    private enum Constants {
        static let sampleIsLiked = true
        static let closeButtonSize = CGSize(width: 40, height: 40)
        static let heartFillSystemName = "heart.fill"
        static let heartSystemName = "heart"
        static let edgeInsetValue: CGFloat = 16
        static let spacingValue: CGFloat = 8

        // Edge insets, которые используются для view внутри scrollView
        // Делаю так, чтобы CollectionView с ингридиентами не прятался по краям из-за границ ScrollView
        static let childrenEdgeInsets = UIEdgeInsets(
            top: spacingValue,
            left: edgeInsetValue,
            bottom: spacingValue,
            right: edgeInsetValue
        )
        // накидываю эти инсеты только на scrollView
        static let parentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

        static let titleFontSize: CGFloat = 30
        static let secondaryTitleFontSize: CGFloat = 20
        static let recipeTitle = "Recipe"
        static let ingredientsTitle = "Ingredients"
        static let crossIconName = "xmark"
        static let closeButtonTopMargin: CGFloat = 50
        static let closeButtonRightMargin: CGFloat = 25
        static let titleTopMargin: CGFloat = 15
        static let spacing: CGFloat = 10
        static let defaultEmojis: [String] = ["😋", "🤤", "🥣", "🥢", "🍴", "🍽", "🥡"]
        static let drinkEmojis: [String] = ["🥴", "🍸", "🍷", "🍾", "🍼"]
    }

    func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }

    func makeContentStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.spacing
        return stackView
    }

    func makeRoundButtonWithBlur(type: RoundButtonWithBlur.ButtonType) -> UIButton {
        RoundButtonWithBlur(type: type)
    }

    func makeMealImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    func getMuliplier(image: UIImage?) -> CGFloat? {
        guard let image = image else { return nil }
        let width = image.size.width
        let height = image.size.height
        return height / width
    }

    func makeTitleView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.layoutMargins = Constants.childrenEdgeInsets
        stackView.layoutMargins.top = Constants.titleTopMargin
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        stackView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        return stackView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }

    func makeLikeButton() -> LikeButton {
        let likeButton = LikeButton()
        likeButton.contentMode = .right
        likeButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return likeButton
    }

    func makeIngredientsStack() -> UIStackView {
        let ingredientsTitle = UILabel()
        ingredientsTitle.text = Constants.ingredientsTitle
        ingredientsTitle.font = UIFont.systemFont(
            ofSize: Constants.secondaryTitleFontSize,
            weight: .bold
        )
        let stackView = UIStackView()
        stackView.layoutMargins = Constants.childrenEdgeInsets
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.spacing

        stackView.addArrangedSubview(ingredientsTitle)

        return stackView
    }

    func makeIngredientCell(name: String, measure: String, drinks: Bool = false) -> UIStackView {
        let ingredientName = UILabel()
        ingredientName.text = name
        ingredientName.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        let quantityName = UILabel()
        quantityName.text = measure
        quantityName.font = UIFont.systemFont(ofSize: 15)

        let emojiLabel = UILabel()
        if let emoji = getEmoji(ingredientName: name, drinks: drinks) {
            emojiLabel.text = emoji
        } else {
            emojiLabel.text = (drinks ? Constants.drinkEmojis : Constants.defaultEmojis)
                .randomElement()
        }
        emojiLabel.font = UIFont.systemFont(ofSize: 30)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .right
        emojiLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.distribution = .fill
        textStack.addArrangedSubview(ingredientName)
        textStack.addArrangedSubview(quantityName)

        let cellStack = UIStackView()
        cellStack.distribution = .fill
        cellStack.alignment = .center
        cellStack.axis = .horizontal
        cellStack.layoutMargins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        cellStack.isLayoutMarginsRelativeArrangement = true
        cellStack.backgroundColor = .secondarySystemBackground
        cellStack.layer.cornerRadius = 10

        cellStack.addArrangedSubview(textStack)
        cellStack.addArrangedSubview(emojiLabel)
        return cellStack
    }

    // is used to make ingredient labels and recipe labels
    func makeRecipeLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }

    func makeRecipeStack() -> UIStackView {
        let recipeTitle = UILabel()
        recipeTitle.text = Constants.recipeTitle
        recipeTitle.font = UIFont.systemFont(
            ofSize: Constants.secondaryTitleFontSize,
            weight: .bold
        )

        let recipeLabel = UILabel()
        recipeLabel.numberOfLines = 0

        let stackView = UIStackView()

        stackView.layoutMargins = Constants.childrenEdgeInsets
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .leading

        stackView.addArrangedSubview(recipeTitle)
        stackView.addArrangedSubview(recipeLabel)

        return stackView
    }

    func makeTextStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }

    func makeLoadingScreen(isHidden: Bool) -> LoadingSplashScreen {
        LoadingSplashScreen(isHidden: isHidden)
    }
}

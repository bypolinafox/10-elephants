//
//  MealViewFactory.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 10.12.2021.
//

import Foundation
import UIKit

class MealViewFactory {
    private struct Constants {
        static let sampleIsLiked = true
        static let sampleImageName = "sampleImage"
        static let closeButtonSize = CGSize(width: 40, height: 40)
        static let heartFillSystemName = "heart.fill"
        static let heartSystemName = "heart"
        static let edgeInsetValue : CGFloat = 16
        static let spacingValue: CGFloat = 8
        
        //Edge insets, которые используются для view внутри scrollView
        //Делаю так, чтобы CollectionView с ингридиентами не прятался по краям из-за границ ScrollView
        static let childrenEdgeInsets = UIEdgeInsets(top: spacingValue, left: edgeInsetValue, bottom: spacingValue, right: edgeInsetValue)
        //накидываю эти инсеты только на scrollView
        static let parentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        static let titleFontSize: CGFloat = 30
        static let secondaryTitleFontSize: CGFloat = 20
        static let recipeTitle = "Рецепт"
        static let ingridientsTitle = "Ингридиенты"
        static let crossIconName = "xmark"
        static let closeButtonTopMargin: CGFloat = 50
        static let closeButtonRightMargin: CGFloat = 25
        static let titleTopMargin: CGFloat = 15
        static let spacing: CGFloat = 10
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
    
    func makeCloseButton() -> UIButton {
        return CloseButton()
    }
    
    func makeMealImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    func getMuliplier(image: UIImage?) -> CGFloat? {
        guard let image = image else {return nil}
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
    
    func makeLikeButton(isLiked: Bool) -> UIButton {
        let likeButton = LikeButton(isLiked: isLiked)
        likeButton.contentMode = .right
        likeButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return likeButton
    }
    
    
    func makeIngridientsStack() -> UIStackView{
        let ingridientsTitle = UILabel()
        ingridientsTitle.text = Constants.ingridientsTitle
        ingridientsTitle.font = UIFont.systemFont(ofSize: Constants.secondaryTitleFontSize, weight: .bold)
        let stackView = UIStackView()
        stackView.layoutMargins = Constants.childrenEdgeInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Constants.spacing
        
        stackView.addArrangedSubview(ingridientsTitle)
        
        return stackView
    }
    
    func makeIngridientCell(name: String, measure: String, emoji: String?) -> UIStackView {
        let ingridientName = UILabel()
        ingridientName.text = name
        ingridientName.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        let quantityName = UILabel()
        quantityName.text = measure
        quantityName.font = UIFont.systemFont(ofSize: 15)
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 30)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .right
        emojiLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        if emoji == nil {emojiLabel.isHidden = true}

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.distribution = .fill
        textStack.addArrangedSubview(ingridientName)
        textStack.addArrangedSubview(quantityName)

        let cellStack = UIStackView()
        cellStack.distribution = .fill
        cellStack.alignment = .center
        cellStack.axis = .horizontal
        cellStack.layoutMargins = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        cellStack.isLayoutMarginsRelativeArrangement = true
        cellStack.backgroundColor = .secondarySystemBackground
        cellStack.layer.cornerRadius = 10

        cellStack.addArrangedSubview(textStack)
        cellStack.addArrangedSubview(emojiLabel)
        return cellStack
    }
    
    //is used to make ingridient labels and recipe labels
    func makeRecipeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
    
    func makeRecipeStack() ->  UIStackView{
        let recipeTitle = UILabel()
        recipeTitle.text = Constants.recipeTitle
        recipeTitle.font = UIFont.systemFont(ofSize: Constants.secondaryTitleFontSize, weight: .bold)
        
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
}

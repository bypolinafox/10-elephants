//
//  IngredientSuggestionCell.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 13.12.2021.
//

import Foundation
import UIKit

final class IngredientSuggestionCell: UICollectionViewCell {
    // is used in ingredientDataSource to set size for cells
    static let titleFont = UIFont.systemFont(ofSize: Constants.titleSize, weight: .bold)

    private enum Constants {
        static let emojiSize: CGFloat = 25
        static let titleSize: CGFloat = 17
        static let cornerRadius: CGFloat = 10
        static let backgroundColor: UIColor = .cellBackgroundColor
        static let activeBackgroundColor: UIColor = .link
        static let labelColor: UIColor = .label
        static let activeLabelColor: UIColor = .systemBackground
        static let edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    var ingredientName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        backgroundColor = Constants.backgroundColor
        layoutMargins = Constants.edgeInsets

        ingredientName = makeTitleLabel()
        addSubview(ingredientName)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        ingredientName.frame = bounds
    }

    func setActiveState(isActive: Bool) {
        if isActive {
            backgroundColor = Constants.activeBackgroundColor
            ingredientName.textColor = Constants.activeLabelColor
            ingredientName.font = UIFont.systemFont(ofSize: Constants.titleSize, weight: .bold)
        } else {
            backgroundColor = Constants.backgroundColor
            ingredientName.textColor = Constants.labelColor
            ingredientName.font = UIFont.systemFont(ofSize: Constants.titleSize, weight: .regular)
        }
    }
}

extension IngredientSuggestionCell {
    private func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: Constants.titleSize, weight: .regular)
        titleLabel.textAlignment = .center
        return titleLabel
    }
}

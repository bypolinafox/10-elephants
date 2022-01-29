//
//  IngredientTableCell.swift
//  TenElephants
//
//  Created by Полина Скалкина on 17.12.2021.
//

import Foundation
import UIKit

final class IngredientTableCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private enum Constants {
        static let ingredientCellHeight = 60.0
    }

    func configure(ingredientData data: IngredientUIData) {
        backgroundColor = .secondarySystemBackground
        if #available(iOS 14.0, *) {
            var configuration = defaultContentConfiguration()
            configuration.text = data.title
            if let type = data.type {
                configuration.secondaryText = type
            }
            contentConfiguration = configuration
        } else {
            textLabel?.text = data.title
            if let type = data.type {
                detailTextLabel?.text = type
            }
        }
    }
}

//
//  IngredientTableCell.swift
//  TenElephants
//
//  Created by Полина Скалкина on 17.12.2021.
//

import Foundation
import UIKit

final class IngredientTableCell: UITableViewCell {
    private lazy var backView = UIView()
    private lazy var textStack = UIStackView()
    private lazy var titleLabel = UILabel()
    private lazy var typeLabel = UILabel()

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
        titleLabel.text = data.title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        if let nonOptionalType = data.type {
            typeLabel.text = nonOptionalType
            typeLabel.font = UIFont.systemFont(ofSize: 15)
            typeLabel.isHidden = false
        } else {
            typeLabel.isHidden = true
        }

        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.distribution = .fill
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(typeLabel)

        backView.layer.cornerRadius = 10

        backView.addSubview(textStack)

        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            textStack.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0),
        ])

        textStack.translatesAutoresizingMaskIntoConstraints = false

        backView.backgroundColor = .secondarySystemBackground

        backView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(backView)

        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            backView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -4),
            backView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

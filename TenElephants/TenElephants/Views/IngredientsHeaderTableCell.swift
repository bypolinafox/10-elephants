//
//  IngredientsHeaderCell.swift
//  TenElephants
//
//  Created by Полина Скалкина on 17.12.2021.
//

import Foundation
import UIKit

final class IngredientsHeaderTableCell: UITableViewCell {
    private lazy var headerLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        contentView.addSubview(headerLabel)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            ),
            headerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])

        headerLabel.text = "Ingredients"
        headerLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
    }
}

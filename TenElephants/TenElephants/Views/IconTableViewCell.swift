//
//  IconTableViewCell.swift
//  TenElephants
//
//  Created by Алексей Шерстнёв on 17.12.2021.
//

import Foundation
import UIKit

final class IconTableViewCell: UITableViewCell {
    private enum Constants {
        static let cellInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        static let imageHeight: CGFloat = 100
        static let iconRadius: CGFloat = 16
    }

    private let iconPreview = UIImageView()
    private let descriptionLabel = UILabel()
    private let cellStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.layoutMargins = Constants.cellInsets
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellStack)

        NSLayoutConstraint.activate([
            cellStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellStack.topAnchor.constraint(equalTo: topAnchor),
            cellStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        iconPreview.translatesAutoresizingMaskIntoConstraints = false
        iconPreview.layer.cornerRadius = Constants.iconRadius
        iconPreview.clipsToBounds = true
        descriptionLabel.numberOfLines = 0
        cellStack.addArrangedSubview(iconPreview)
        cellStack.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            iconPreview.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            iconPreview.widthAnchor.constraint(equalToConstant: Constants.imageHeight),
        ])
    }

    func fillIn(image: UIImage, description: String) {
        iconPreview.image = image
        descriptionLabel.text = description
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

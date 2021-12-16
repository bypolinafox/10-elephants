//
//  NothingFoundStack.swift
//  TenElephants
//
//  Created by Алексей Шерстнёв on 16.12.2021.
//

import Foundation
import UIKit

final class NothingFoundStack: UIStackView {
    private enum Constants {
        static let nothingFoundEmojiLabelFont = UIFont.systemFont(ofSize: 50)
        static let nothingFoundTitleLabelFont = UIFont.systemFont(ofSize: 30, weight: .bold)
        static let nothingFoundDesriptionLabelFont = UIFont.systemFont(ofSize: 15)
        static let nothingFoundSpacing: CGFloat = 5
    }

    init(
        emoji: String,
        title: String,
        description: String
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .center
        distribution = .fill
        spacing = Constants.nothingFoundSpacing

        let emojiLabel = UILabel()
        emojiLabel.font = Constants.nothingFoundEmojiLabelFont
        emojiLabel.text = emoji

        let titleLabel = UILabel()
        titleLabel.font = Constants.nothingFoundTitleLabelFont
        titleLabel.text = title

        let descLabel = UILabel()
        descLabel.font = Constants.nothingFoundDesriptionLabelFont
        descLabel.text = description

        addArrangedSubview(emojiLabel)
        addArrangedSubview(titleLabel)
        addArrangedSubview(descLabel)
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

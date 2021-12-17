//
//  Header.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 13.12.2021.
//

import Foundation
import UIKit

final class HeaderCollectionView: UICollectionReusableView {
    enum TitleFontStyle {
        case big
        case medium
    }

    lazy var label: UILabel = makeTitleLabel()

    private enum Constants {
        static let labelGap: CGFloat = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("has not been implemented")
    }
}

extension HeaderCollectionView {
    func makeTitleLabel() -> UILabel {
        let label = UILabel(
            frame: CGRect(
                x: Constants.labelGap, y: 0,
                width: frame.width - 2 * Constants.labelGap,
                height: frame.height
            )
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }

    func setTitle(_ text: String, style: TitleFontStyle) {
        label.text = text
        label.font = style.font
    }
}

extension HeaderCollectionView.TitleFontStyle {
    var font: UIFont {
        switch self {
        case .big: return UIFont.systemFont(ofSize: 30, weight: .bold)
        case .medium: return UIFont.systemFont(ofSize: 20, weight: .bold)
        }
    }
}

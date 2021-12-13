//
//  Header.swift
//  Ten Elephants
//
//  Created by Дарья Домрачева on 13.12.2021.
//

import Foundation
import UIKit

class HeaderCollectionView: UICollectionReusableView {

    lazy var label: UILabel = makeTitleLabel()
    
    private enum Constants {
        static let fontSize: CGFloat = 20
        static let labelGap: CGFloat = 10
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        self.addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("has not been implemented")
    }
    
}

extension HeaderCollectionView {
    func makeTitleLabel() -> UILabel {
        let label = UILabel(
            frame: CGRect(
                x: Constants.labelGap, y: 0,
                width: self.frame.width - 2 * Constants.labelGap,
                height: self.frame.height
            )
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .bold)
        return label
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}

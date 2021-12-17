//
//  CloseButton.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 12.12.2021.
//

import Foundation
import UIKit

final class RoundButtonWithBlur: UIButton {
    enum ButtonType {
        case refresh
        case close
    }

    private enum Constants {
        static let tintColor: UIColor = .black
        static let blurStyle: UIBlurEffect.Style = .light
    }

    let blur = UIVisualEffectView(effect: UIBlurEffect(style: Constants.blurStyle))
    let type: ButtonType

    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)

        self.setTitle(nil, for: .normal)
        self.backgroundColor = .clear
        self.setImage(type.icon, for: .normal)
        self.tintColor = Constants.tintColor
        blur.isUserInteractionEnabled = false
        blur.layer.masksToBounds = true
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView {
            self.bringSubviewToFront(imageView)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = self.bounds
        blur.layer.cornerRadius = blur.frame.width / 2
    }
}

extension RoundButtonWithBlur.ButtonType {
    var icon: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        switch self {
        case .close: return UIImage(systemName: "xmark", withConfiguration: config)!
        case .refresh: return UIImage(systemName: "shuffle", withConfiguration: config)!
        }
    }
}

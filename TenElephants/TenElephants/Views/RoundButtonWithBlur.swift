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

        setTitle(nil, for: .normal)
        backgroundColor = .clear
        setImage(type.icon, for: .normal)
        tintColor = Constants.tintColor
        blur.isUserInteractionEnabled = false
        blur.layer.masksToBounds = true
        self.insertSubview(blur, at: 0)
        if let imageView = imageView {
            bringSubviewToFront(imageView)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds
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

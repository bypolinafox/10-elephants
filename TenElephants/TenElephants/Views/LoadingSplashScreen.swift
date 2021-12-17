//
//  LoadingSplashScreen.swift
//  TenElephants
//
//  Created by Алексей Шерстнёв on 16.12.2021.
//

import Foundation
import UIKit

class LoadingSplashScreen: UIView {
    private enum Constants {
        static let loadingScreenAppearanceDuration: TimeInterval = 0.5
    }

    private let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    private let loadingView = UIActivityIndicatorView(style: .large)

    func setAppearance(shouldHide: Bool, animated: Bool) {
        guard animated else {
            self.isHidden = shouldHide
            return
        }

        if shouldHide {
            UIView.animate(withDuration: Constants.loadingScreenAppearanceDuration, animations: {
                self.layer.opacity = 0
            }, completion: { _ in
                self.isHidden = true
            })
            return
        }
        self.layer.opacity = 0
        self.isHidden = false
        UIView.animate(withDuration: Constants.loadingScreenAppearanceDuration, animations: {
            self.layer.opacity = 1
        })
    }

    init(isHidden: Bool) {
        super.init(frame: .zero)

        blur.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false

        loadingView.startAnimating()
        blur.contentView.addSubview(loadingView)
        self.addSubview(blur)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        self.layer.opacity = isHidden ? 0 : 1
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds
    }
}

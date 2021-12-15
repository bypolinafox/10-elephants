//
//  CloseButton.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 12.12.2021.
//

import Foundation
import UIKit

final class CloseButton: UIButton {
    private enum Constants {
        static let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        static let icon = UIImage(systemName: "xmark", withConfiguration: config)
        static let tintColor: UIColor = .black
        static let blurStyle: UIBlurEffect.Style = .light
    }
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: Constants.blurStyle))
    
    init(){
        super.init(frame: .zero)

        self.setTitle(nil, for: .normal)
        self.backgroundColor = .clear
        self.setImage(Constants.icon, for: .normal)
        self.tintColor = Constants.tintColor
        blur.isUserInteractionEnabled = false
        blur.layer.masksToBounds = true
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = self.bounds
        blur.layer.cornerRadius = blur.frame.width / 2
    }
}

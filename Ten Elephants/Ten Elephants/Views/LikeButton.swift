//
//  LikeButton.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 12.12.2021.
//

import Foundation
import UIKit

final class LikeButton: UIButton {
    private enum Constants {
        static let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .medium)
        static let fillIcon = UIImage(systemName: "heart.fill", withConfiguration: config)
        static let contourIcon = UIImage(systemName: "heart", withConfiguration: config)
        static let activeTint: UIColor = .red
        static let notActiveTint: UIColor = .label
    }

    //достаточно просто выставить isLiked, и кнопка поменяет внешний вид
    var isLiked: Bool = false{
        didSet {
            updateImage()
        }
    }
    
    private func updateImage() {
        switch isLiked {
        case true:
            self.setImage(Constants.fillIcon, for: .normal)
            self.tintColor = Constants.activeTint
        case false:
            self.setImage(Constants.contourIcon, for: .normal)
            self.tintColor = Constants.notActiveTint
        }
    }
    
    init(){
        super.init(frame: .zero)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  AddBlurEffect.swift
//  Ten Elephants
//
//  Created by Алексей Шерстнёв on 10.12.2021.
//

import Foundation
import UIKit

extension UIButton
{
    func addBlurEffect(style: UIBlurEffect.Style = .light, cornerRadius: CGFloat)
    {
        self.backgroundColor = .clear
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        blur.layer.cornerRadius = cornerRadius
        blur.layer.masksToBounds = true
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}

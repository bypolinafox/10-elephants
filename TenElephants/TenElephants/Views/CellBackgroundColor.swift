//
//  CellBackgroundColor.swift
//  TenElephants
//
//  Created by Алексей Шерстнёв on 17.12.2021.
//

import Foundation
import UIKit

extension UIColor {
    static var cellBackgroundColor: UIColor {
        UIColor { traits -> UIColor in
            traits.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemBackground
        }
    }
}

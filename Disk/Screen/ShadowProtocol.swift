//
//  ShadowProtocol.swift
//  Disk
//
//  Created by Георгий on 09.09.2024.
//

import Foundation
import UIKit

protocol Shadowable: AnyObject {
    func applyShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat)
}

extension UIView: Shadowable {
    func applyShadow(color: UIColor = .black, offset: CGSize = CGSize(width: 5, height: 5), opacity: Float = 0.7, radius: CGFloat = 5) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}


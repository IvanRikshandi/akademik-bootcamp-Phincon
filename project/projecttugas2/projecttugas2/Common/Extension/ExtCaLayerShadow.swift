import Foundation
import UIKit
import QuartzCore

extension CALayer {
    func applyShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowRadius = radius
        shadowOpacity = opacity
        masksToBounds = false
    }
}

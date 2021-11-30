//
//  Button.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import Foundation
import UIKit

class Button: UIButton {
    
    convenience init(style: Button.Style, title: String) {
        self.init(style: style)
        
        setTitle(title, for: .normal)
        setTitleColor(Color.primary, for: .normal)
    }
    
    convenience init(style: Button.Style, image: UIImage) {
        self.init(style: style)
        
        setImage(image, for: .normal)
        tintColor = Color.accent
    }
    
    init(style: Button.Style) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 15
        backgroundColor = style.backgroundColor
        layer.borderColor = Color.accent.cgColor
        layer.borderWidth = style.borderWidth
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

extension Button {
    
    enum Style {
        case primary, secondary
        
        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return Color.accent
            case .secondary:
                return Color.secondary
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .primary:
                return 0
            case .secondary:
                return 3
            }
        }
    }
    
}

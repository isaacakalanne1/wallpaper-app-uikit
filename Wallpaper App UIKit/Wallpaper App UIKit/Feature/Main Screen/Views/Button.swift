//
//  Button.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import UIKit

class Button: UIButton {
    
    convenience init(style: Button.Style, title: String?) {
        self.init(style: style)
        
        setTitle(title, for: .normal)
        setTitleColor(style.titleColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    
    convenience init(style: Button.Style, image: UIImage) {
        self.init(style: style)
        
        setImage(image, for: .normal)
        tintColor = Color.accent
    }
    
    init(style: Button.Style) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Button.cornerRadius
        backgroundColor = style.backgroundColor
        layer.borderColor = Button.borderColor.cgColor
        layer.borderWidth = Button.borderWidth
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

extension Button {
    
    static var borderWidth: CGFloat {
        return 3
    }
    
    static var borderColor: UIColor {
        return Color.accent
    }
    
    static var cornerRadius: CGFloat {
        return 12
    }
    
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
        
        var titleColor: UIColor {
            switch self {
            case .primary:
                return Color.primary
            case .secondary:
                return Color.accent
            }
        }
    }
    
}

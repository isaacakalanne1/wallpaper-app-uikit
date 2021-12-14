//
//  FilterButton.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import UIKit

class FilterButton: UIButton {
    
    let margin: CGFloat = 5
    
    init(filter: Filter, image: UIImage?, isSelected: Bool = false) {
        super.init(frame: .zero)
        
        let borderWidth = isSelected ? Button.Style.secondary.borderWidth : 0
        let cornerRadius = Button.Style.secondary.cornerRadius
        
        configuration?.title = filter.type.title
        configuration?.image = image
        
        imageView?.layer.cornerRadius = cornerRadius
        imageView?.layer.cornerCurve = .continuous
        
        imageView?.layer.borderWidth = borderWidth
        imageView?.layer.borderColor = Color.accent.cgColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(_ wallpaper: UIImage) {
        configuration?.image = wallpaper
    }
    
}

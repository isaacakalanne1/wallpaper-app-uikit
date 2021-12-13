//
//  FilterButton.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import UIKit

class FilterButton: UIButton {
    
    let margin: CGFloat = 5
    
    init(filter: Filter, image: UIImage) {
        super.init(frame: .zero)
        
        configuration?.title = filter.type.title
        configuration?.image = image
        
        imageView?.layer.cornerCurve = .continuous
        imageView?.layer.borderWidth = Button.Style.secondary.borderWidth
        imageView?.layer.cornerRadius = Button.Style.secondary.cornerRadius
        imageView?.layer.borderColor = Color.accent.cgColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

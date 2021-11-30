//
//  Slider.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import Foundation
import UIKit

class Slider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = Color.accent
        
        value = 0.75
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

//
//  Slider.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import UIKit

protocol SliderDelegate: AnyObject {
    func didChangeValue(_ value: Float)
}

class Slider: UISlider {
    
    let delegate: SliderDelegate?
    
    init(delegate: SliderDelegate?, initialValue: Float) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = Color.accent
        
        value = initialValue
        
        addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                break
            case .moved:
                break
            case .ended:
                delegate?.didChangeValue(value)
            default:
                break
            }
        }
    }
    
}

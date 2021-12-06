//
//  SecondaryButtonContainer.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 06/12/2021.
//

import UIKit

class SecondaryButtonContainer: UIView {
    
    private let margin: CGFloat = 5
    private let viewWidth: CGFloat = 100
    
    let primaryButton = Button(style: .primary, title: "Apply")
    let secondaryButton = Button(style: .secondary, title: "Cancel")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Color.secondary
        
        addSubview(primaryButton)
        addSubview(secondaryButton)
        
        NSLayoutConstraint.activate([
            primaryButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: margin),
            primaryButton.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            primaryButton.widthAnchor.constraint(equalToConstant: viewWidth),
            
            secondaryButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -margin),
            secondaryButton.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            secondaryButton.widthAnchor.constraint(equalToConstant: viewWidth)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

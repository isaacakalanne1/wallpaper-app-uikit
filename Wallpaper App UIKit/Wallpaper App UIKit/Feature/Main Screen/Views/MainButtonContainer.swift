//
//  MainButtonContainer.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 06/12/2021.
//

import UIKit

class MainButtonContainer: UIView {
    
    let downloadButton = Button(style: .primary, title: "Download")
    let menuButton = Button(style: .secondary, image: UIImage(systemName: "line.3.horizontal")!)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(menuButton)
        addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            menuButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuButton.heightAnchor.constraint(equalToConstant: 60),
            menuButton.widthAnchor.constraint(equalToConstant: 60),
            menuButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            downloadButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -10),
            downloadButton.heightAnchor.constraint(equalToConstant: 60),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
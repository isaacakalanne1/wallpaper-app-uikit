//
//  FilterView.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import UIKit

class FilterView: UIView {
    
    let margin: CGFloat = 5
    
    let filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = Color.accent.cgColor
        imageView.layer.borderWidth = 5
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(filterImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            filterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            filterImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            filterImageView.widthAnchor.constraint(equalToConstant: 30),
            filterImageView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: filterImageView.bottomAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: filterImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: filterImageView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

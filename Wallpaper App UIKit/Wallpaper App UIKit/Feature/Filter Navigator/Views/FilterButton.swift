//
//  FilterButton.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import UIKit

class FilterButton: UIButton {
    
    lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
        
        let borderWidth = Button.Style.secondary.borderWidth
        imageView.layer.borderWidth = borderWidth
        
        let cornerRadius = Button.Style.secondary.cornerRadius
        imageView.layer.cornerRadius = cornerRadius
        
        return imageView
    }()
    lazy var filterTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = Color.accent
        return label
    }()
    
    let margin: CGFloat = 5
    
    init(filter: Filter, image: UIImage?, isSelected: Bool = false) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        filterImageView.image = image
        filterTitleLabel.text = filter.type.title
        
        addSubview(filterImageView)
        addSubview(filterTitleLabel)
        
        NSLayoutConstraint.activate([
            filterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            filterImageView.widthAnchor.constraint(equalToConstant: 57),
            filterImageView.heightAnchor.constraint(equalToConstant: 57),
            
            filterTitleLabel.topAnchor.constraint(equalTo: filterImageView.bottomAnchor, constant: 2),
            filterTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterTitleLabel.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(_ wallpaper: UIImage) {
        filterImageView.image = wallpaper
    }
    
}

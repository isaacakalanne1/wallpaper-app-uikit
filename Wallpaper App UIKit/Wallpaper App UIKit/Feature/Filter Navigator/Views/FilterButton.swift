//
//  FilterButton.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didSelectFilter(_ filter: Filter)
    func applyFilter()
    func cancelFilter()
    func clearAllFilters()
}

class FilterButton: UIButton {
    
    lazy var filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
        
        imageView.layer.borderWidth = Button.borderWidth
        
        imageView.layer.cornerRadius = Button.cornerRadius
        
        return imageView
    }()
    lazy var filterTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    let margin: CGFloat = 5
    let filter: Filter
    var isButtonSelected: Bool
    let delegate: FilterDelegate?
    
    init(filter: Filter, image: UIImage? = nil, isSelected: Bool = false, delegate: FilterDelegate?) {
        self.filter = filter
        self.isButtonSelected = isSelected
        self.delegate = delegate
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        filterImageView.image = image
        filterTitleLabel.text = filter.title
        
        updateFormatting(isSelected: isSelected)
        
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
        
        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(_ wallpaper: UIImage) {
        filterImageView.image = wallpaper
    }
    
    func updateFormatting(isSelected: Bool) {
        isButtonSelected = isSelected
        if isSelected {
            filterTitleLabel.textColor = Color.accent
            filterImageView.layer.borderColor = Button.borderColor.cgColor
        } else {
            filterTitleLabel.textColor = .systemGray
            filterImageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @objc func didTapButton(_ sender: FilterButton) {
        if sender.filter == .clear {
            delegate?.clearAllFilters()
        } else {
            delegate?.didSelectFilter(filter)
        }
    }
    
}

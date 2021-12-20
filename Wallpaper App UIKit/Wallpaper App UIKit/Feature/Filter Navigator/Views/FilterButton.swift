//
//  FilterButton.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didSelectFilter(_ filter: Filter)
    func finishedFilteringWallpaper()
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
    
    lazy var lockView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.borderWidth = Button.borderWidth
        imageView.layer.cornerRadius = Button.cornerRadius
        imageView.backgroundColor = .black.withAlphaComponent(0.5)
        
        return imageView
    }()
    
    lazy var lockIconView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "lock.fill")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Color.accent
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
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
        
        if let img = image {
            updateWallpaper(img)
        }
        
        filterTitleLabel.text = filter.title
        
        updateFormatting(isSelected: isSelected)
        
        lockView.isHidden = !filter.isLockedByDefault
        
        addSubview(filterImageView)
        lockView.addSubview(lockIconView)
        addSubview(lockView)
        addSubview(filterTitleLabel)
        
        NSLayoutConstraint.activate([
            filterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            filterImageView.widthAnchor.constraint(equalToConstant: 57),
            filterImageView.heightAnchor.constraint(equalToConstant: 57),
            
            lockView.leadingAnchor.constraint(equalTo: filterImageView.leadingAnchor),
            lockView.trailingAnchor.constraint(equalTo: filterImageView.trailingAnchor),
            lockView.topAnchor.constraint(equalTo: filterImageView.topAnchor),
            lockView.bottomAnchor.constraint(equalTo: filterImageView.bottomAnchor),

            lockIconView.widthAnchor.constraint(equalToConstant: 20),
            lockIconView.heightAnchor.constraint(equalToConstant: 20),
            lockIconView.bottomAnchor.constraint(equalTo: lockView.bottomAnchor, constant: -3),
            lockIconView.trailingAnchor.constraint(equalTo: lockView.trailingAnchor, constant: -3),
            
            filterTitleLabel.topAnchor.constraint(equalTo: filterImageView.bottomAnchor, constant: 2),
            filterTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterTitleLabel.widthAnchor.constraint(equalToConstant: 70),
        ])
        
        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(_ wallpaper: UIImage) {
        
        if filter == .clear {
            UIView.transition(with: filterImageView, duration: Animation.length, options: .transitionCrossDissolve) {
                self.filterImageView.image = wallpaper
            }
        } else {
            
            DispatchQueue.global(qos: .userInitiated).async {
                let editedImage = ImageEditor.filterImage(wallpaper, with: self.filter, sliderValue: self.filter.filterButtonPreviewSliderValue)

                DispatchQueue.main.async {
                    UIView.transition(with: self.filterImageView, duration: Animation.length, options: .transitionCrossDissolve) {
                        self.filterImageView.image = editedImage
                    }
                }
            }
        }
    }
    
    func updateFormatting(isSelected: Bool) {
        isButtonSelected = isSelected
        updateBorder(isSelected: isSelected)
        
        if isSelected {
            filterTitleLabel.textColor = Color.accent
        } else {
            filterTitleLabel.textColor = .systemGray
        }
    }
    
    func updateBorder(isSelected: Bool) {
        let borderColor = isSelected ? Button.borderColor.cgColor : UIColor.clear.cgColor
        if filter.isLockedByDefault {
            lockView.layer.borderColor = borderColor
        } else {
            filterImageView.layer.borderColor = borderColor
        }
    }
    
    @objc func didTapButton(_ sender: FilterButton) {
        delegate?.didSelectFilter(filter)
    }
    
}

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
        
        if let img = image {
            updateWallpaper(img)
        }
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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func updateWallpaper(_ wallpaper: UIImage) {
        let smallImage = resizeImage(image: wallpaper, targetSize: CGSize(width: 200, height: 200))
        self.filterImageView.image = smallImage
        DispatchQueue.global(qos: .userInitiated).async {
            let editedImage = ImageEditor.filterImage(smallImage, with: self.filter, sliderValue: 0.75)

            DispatchQueue.main.async {
                self.filterImageView.image = editedImage
            }
        }
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
        delegate?.didSelectFilter(filter)
    }
    
}

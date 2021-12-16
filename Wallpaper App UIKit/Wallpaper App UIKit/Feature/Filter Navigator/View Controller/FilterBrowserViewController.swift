//
//  FilterBrowserViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import UIKit

class FilterBrowserViewController: UIViewController {
    
    let margin: CGFloat = 10
    let filters = Filter.allCases
    var editedWallpaper: UIImage?
    var editedWallpaperReducedSize: UIImage?
    
    var originalWallpaper: UIImage?
    var originalWallpaperReducedSize: UIImage?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        return stackView
    }()
    
    let delegate: FilterDelegate?
    
    init(delegate: FilterDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        filters.forEach { filter in
            if filter != .clear {
                let button = FilterButton(filter: filter, delegate: self)
                stackView.addArrangedSubview(button)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: 70),
                ])
            }
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(editedWallpaper: UIImage, originalWallpaper: UIImage) {
        self.editedWallpaper = editedWallpaper
        self.originalWallpaper = originalWallpaper
        DispatchQueue.global(qos: .userInitiated).async {
            let newSize = CGSize(width: 200, height: 200)
            self.editedWallpaperReducedSize = ImageEditor.resizeImage(image: editedWallpaper,
                                                                       targetSize: newSize)
            self.originalWallpaperReducedSize = ImageEditor.resizeImage(image: originalWallpaper,
                                                                        targetSize: newSize)

            DispatchQueue.main.async {
                self.stackView.arrangedSubviews.forEach { view in
                    if let button = view as? FilterButton,
                       let wallpaper = button.filter == .clear ? self.originalWallpaperReducedSize : self.editedWallpaperReducedSize {
                        button.updateWallpaper(wallpaper)
                    }
                }
            }
        }
    }
    
    func deselectButtons() {
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? FilterButton {
                button.updateFormatting(isSelected: false)
            }
        }
    }
    
    func updateClearFiltersButtonVisibility(isWallpaperEdited: Bool) {
        let containsClearButton = stackView.arrangedSubviews.contains(where: { ($0 as? FilterButton)?.filter == .clear})
        
        if isWallpaperEdited {
            if !containsClearButton {
                addClearFiltersButton()
            }
        } else {
            removeClearFiltersButton()
        }
    }
    
    func addClearFiltersButton() {
        let button = FilterButton(filter: .clear,
                                  image: originalWallpaperReducedSize,
                                  isSelected: false,
                                  delegate: self)
        stackView.insertArrangedSubview(button, at: 0)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    func removeClearFiltersButton() {
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? FilterButton,
               button.filter == .clear {
                button.removeFromSuperview()
                stackView.removeArrangedSubview(button)
            }
        }
    }
}

extension FilterBrowserViewController: FilterDelegate {
    
    func didSelectFilter(_ filter: Filter) {
        delegate?.didSelectFilter(filter)
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? FilterButton {
                let isSelected = filter == button.filter
                button.updateFormatting(isSelected: isSelected)
            }
        }
    }
    
    func finishedFilteringWallpaper() {
        
    }
    
    func applyFilter() {
        
    }
    
    func cancelFilter() {
        
    }
    
    func clearAllFilters() {
        removeClearFiltersButton()
        delegate?.clearAllFilters()
    }
}

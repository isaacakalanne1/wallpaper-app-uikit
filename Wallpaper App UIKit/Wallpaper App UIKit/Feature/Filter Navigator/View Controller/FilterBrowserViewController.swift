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
    
    lazy var resetButton = FilterButton(filter: .reset,
                                        image: originalWallpaperReducedSize,
                                        title: "Reset",
                                        isSelected: false,
                                        delegate: self)
    
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
    
    lazy var resetButtonShowWidth = resetButton.widthAnchor.constraint(equalToConstant: 70)
    lazy var resetButtonHideWidth = resetButton.widthAnchor.constraint(equalToConstant: 0)
    
    let delegate: FilterDelegate?
    var currentFilter: Filter?
    
    init(delegate: FilterDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(scrollView)
        view.addSubview(resetButton)
        scrollView.addSubview(stackView)
        
        filters.forEach { filter in
            if filter != .reset {
                let button = FilterButton(filter: filter, delegate: self)
                stackView.addArrangedSubview(button)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: 70),
                ])
            }
        }
        
        NSLayoutConstraint.activate([
            resetButton.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resetButton.topAnchor.constraint(equalTo: view.topAnchor),
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: resetButton.trailingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        updateResetButtonVisibility(isHidden: true)
        
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    @objc func resetButtonTapped() {
        resetButton.updateFormatting(isSelected: true)
        delegate?.didSelectResetButton()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func unlock(filter: Filter?) {
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? FilterButton,
               button.filter == filter {
                button.unlockFilter()
            }
        }
    }
    
    func updateWallpaper(editedWallpaper: UIImage, originalWallpaper: UIImage) {
        self.editedWallpaper = editedWallpaper
        self.originalWallpaper = originalWallpaper
        
        updateResetButtonVisibility(isHidden: editedWallpaper == originalWallpaper)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let newSize = CGSize(width: 200, height: 200)
            self.editedWallpaperReducedSize = ImageEditor.resizeImage(image: editedWallpaper,
                                                                       targetSize: newSize)
            self.originalWallpaperReducedSize = ImageEditor.resizeImage(image: originalWallpaper,
                                                                        targetSize: newSize)

            DispatchQueue.main.async {
                self.resetButton.filterImageView.image = self.originalWallpaperReducedSize
                
                self.stackView.arrangedSubviews.forEach { view in
                    if let button = view as? FilterButton,
                       let wallpaper = self.editedWallpaperReducedSize {
                        button.updateWallpaper(wallpaper)
                    }
                }
            }
        }
    }
    
    func updateResetButtonSelection(isSelected: Bool) {
        resetButton.updateFormatting(isSelected: isSelected)
    }
    
    func updateResetButtonVisibility(isHidden: Bool) {
        resetButton.isHidden = isHidden
        resetButtonShowWidth.isActive = !isHidden
        resetButtonHideWidth.isActive = isHidden
    }
    
    func deselectButtons() {
        currentFilter = nil
        resetButton.updateFormatting(isSelected: false)
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? FilterButton {
                button.updateFormatting(isSelected: false)
            }
        }
    }
}

extension FilterBrowserViewController: FilterDelegate {
    
    func didSelectFilter(_ filter: Filter) {
        if currentFilter != filter {
            currentFilter = filter
            delegate?.didSelectFilter(filter)
            stackView.arrangedSubviews.forEach { view in
                if let button = view as? FilterButton {
                    let isSelected = filter == button.filter
                    button.updateFormatting(isSelected: isSelected)
                }
            }
        }
    }
    
    func didSelectResetButton() {
        delegate?.didSelectResetButton()
    }
    
    func finishedFilteringWallpaper() {
        
    }
    
    func applyFilter() {
        delegate?.applyFilter()
    }
    
    func cancelFilter() {
        currentFilter = nil
    }
    
    func clearAllFilters() {
        updateResetButtonVisibility(isHidden: true)
        delegate?.clearAllFilters()
    }
}

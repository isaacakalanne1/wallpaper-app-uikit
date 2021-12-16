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
    var currentWallpaper: UIImage?
    
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
    
    var wallpaper: UIImage?
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
    
    func updateWallpaper(_ wallpaper: UIImage) {
        currentWallpaper = wallpaper
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? FilterButton {
                button.updateWallpaper(wallpaper)
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
    
    func updateClearFiltersButtonVisibility(appliedFilter filter: Filter) {
        if filter == .clear {
            removeClearFiltersButton()
        } else {
            addClearFiltersButton()
        }
    }
    
    func addClearFiltersButton() {
        let button = FilterButton(filter: .clear, image: currentWallpaper, isSelected: false, delegate: self)
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
    
    func applyFilter() {
        
    }
    
    func cancelFilter() {
        
    }
    
    func clearAllFilters() {
        removeClearFiltersButton()
        delegate?.clearAllFilters()
    }
}

//
//  FilterBrowserViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import UIKit

class FilterBrowserViewController: UIViewController {
    
    let margin: CGFloat = 10
    var filters = FilterData.allFilters
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = margin
        stackView.alignment = .leading
        return stackView
    }()
    
    var wallpaper: UIImage?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(stackView)
        filters.forEach { filter in
            let button = FilterButton(filter: filter, image: self.wallpaper)
            stackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(_ wallpaper: UIImage) {
        stackView.arrangedSubviews.forEach { view in
            if let button = view as? FilterButton {
                button.updateWallpaper(wallpaper)
            }
        }
    }
}

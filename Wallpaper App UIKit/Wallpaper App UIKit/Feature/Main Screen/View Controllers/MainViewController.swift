//
//  ViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private let margin: CGFloat = 10
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = margin
        stackView.alignment = .leading
        return stackView
    }()
    
    let wallpaperBrowserView = UIView()
    lazy var secondaryButtonContainer = SecondaryButtonContainer(delegate: self)
    
    var sliderValue: Float = 0.75
    lazy var slider = Slider(delegate: self, initialValue: sliderValue)
    
    var currentFilter: Filter?
    
    let filterNavigatorView = UIView()
    lazy var mainButtonContainer = MainButtonContainer(downloadDelegate: self, announcementDelegate: self)
    
    lazy var filterNavigatorVC = FilterNavigatorViewController(filterDelegate: self)
    lazy var wallpaperBrowserVC = WallpaperBrowserController(wallpaperDelegate: self, announcementDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.primary
        
        wallpaperBrowserView.translatesAutoresizingMaskIntoConstraints = false
        filterNavigatorView.translatesAutoresizingMaskIntoConstraints = false
        
        insert(filterNavigatorVC, into: filterNavigatorView)
        insert(wallpaperBrowserVC, into: wallpaperBrowserView)
        
        stackView.addArrangedSubview(wallpaperBrowserView)
        stackView.addArrangedSubview(secondaryButtonContainer)
        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(filterNavigatorView)
        stackView.addArrangedSubview(mainButtonContainer)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            
            wallpaperBrowserView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            wallpaperBrowserView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            secondaryButtonContainer.heightAnchor.constraint(equalToConstant: 45),
            secondaryButtonContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            secondaryButtonContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            slider.heightAnchor.constraint(equalToConstant: 30),
            slider.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: margin),
            slider.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -margin),
            
            filterNavigatorView.heightAnchor.constraint(equalToConstant: 90),
            filterNavigatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            filterNavigatorView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            mainButtonContainer.heightAnchor.constraint(equalToConstant: 60),
            mainButtonContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: margin),
            mainButtonContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -margin),
        ])
    }

}

extension MainViewController: WallpaperDelegate {
    func didChange(wallpaper: UIImage) {
        filterNavigatorVC.updateWallpaper(wallpaper)
    }
}

extension MainViewController: FilterDelegate {
    
    func didSelectFilter(_ filter: Filter) {
        currentFilter = filter
        wallpaperBrowserVC.previewFilter(filter, sliderValue: sliderValue)
        secondaryButtonContainer.toggleButtons(.show)
    }
    
    func applyFilter() {
        guard let filter = currentFilter else { return }
        secondaryButtonContainer.displayAnnouncement("Applied \(filter.title)")
        filterNavigatorVC.updateButtonVisibility(appliedFilter: filter)
        
        wallpaperBrowserVC.applyFilter(filter)
        
        filterNavigatorVC.deselectButtons()
        secondaryButtonContainer.toggleButtons(.hide)
        currentFilter = nil
    }
    
    func cancelFilter() {
        wallpaperBrowserVC.cancelFilter()
        
        filterNavigatorVC.deselectButtons()
        secondaryButtonContainer.toggleButtons(.hide)
        currentFilter = nil
    }
    
    func clearAllFilters() {
        wallpaperBrowserVC.clearAllFilters()
    }
}

extension MainViewController: SliderDelegate {
    func didChangeValue(_ value: Float) {
        sliderValue = value
        guard let filter = currentFilter else { return }
        
        wallpaperBrowserVC.previewFilter(filter, sliderValue: value)
    }
}

extension MainViewController: DownloadDelegate {
    func saveWallpaperToPhotos() {
        wallpaperBrowserVC.saveWallpaperToPhotos()
    }
}

extension MainViewController: AnnouncementDelegate {
    func displayAnnouncement(_ text: String) {
        secondaryButtonContainer.displayAnnouncement(text)
    }
}

extension UIViewController {
    
    func insert(_ viewController: UIViewController, into view: UIView) {
        viewController.view.frame = view.bounds
        self.addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
}


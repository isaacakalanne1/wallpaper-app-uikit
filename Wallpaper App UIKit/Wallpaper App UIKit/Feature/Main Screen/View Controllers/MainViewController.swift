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
    let secondaryButtonContainer = SecondaryButtonContainer()
    let slider = Slider()
    let filterNavigatorView = UIView()
    let mainButtonContainer = MainButtonContainer()
    
    let filterNavigatorVC = FilterNavigatorViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.primary
        
        wallpaperBrowserView.translatesAutoresizingMaskIntoConstraints = false
        filterNavigatorView.translatesAutoresizingMaskIntoConstraints = false
        
        insert(filterNavigatorVC, into: filterNavigatorView)
        insert(WallpaperBrowserController(wallpaperDelegate: self), into: wallpaperBrowserView)
        
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
    
    func didApply(filter: Filter) {
        
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


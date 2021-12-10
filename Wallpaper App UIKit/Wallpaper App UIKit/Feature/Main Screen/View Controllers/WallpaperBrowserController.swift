//
//  WallpaperBrowserController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 10/12/2021.
//

import UIKit

class WallpaperBrowserController: UIPageViewController {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.color = Color.accent
        return spinner
    }()
    
    var listOfVCs: [UIViewController] = []
    var currentIndex: Int = 0
    
    var listOfURLs: [String] = []
    let imgurApi = ImgurAPI()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let vc = UIViewController()
        vc.view.backgroundColor = .systemOrange
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        dataSource = self
        delegate = self
        
        imgurApi.downloadData(forHash: "SqumB") { [weak self] result in
            switch result {
            case .success(let data):
                self?.listOfURLs = data.links
                
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    let firstLink = data.links[0]
                    self?.setViewControllers([WallpaperViewController(link: firstLink)], direction: .forward, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Failed! Error is \(error)")
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

extension WallpaperBrowserController: UIPageViewControllerDelegate {
    
}

extension WallpaperBrowserController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        return vc
    }
    
}

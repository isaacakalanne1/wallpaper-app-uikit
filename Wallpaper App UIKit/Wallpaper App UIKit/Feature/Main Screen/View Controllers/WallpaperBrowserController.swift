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
    
    let wallpaperDelegate: WallpaperDelegate?
    
    init(wallpaperDelegate: WallpaperDelegate? = nil) {
        self.wallpaperDelegate = wallpaperDelegate
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        dataSource = self
        delegate = self
        
        imgurApi.downloadData(forHash: "zOcv3") { [weak self] result in
            switch result {
            case .success(let data):
                self?.listOfURLs = data.links
                
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    data.links.forEach { link in
                        self?.listOfVCs.append(WallpaperViewController(link: link, delegate: self))
                    }
                    if let vc = self?.listOfVCs[0] {
                        self?.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                print("Failed! Error is \(error)")
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

extension WallpaperBrowserController: WallpaperDelegate {
    func didChange(wallpaper: UIImage) {
        wallpaperDelegate?.didChange(wallpaper: wallpaper)
    }
    
    func didApply(filter: Filter) {
        
    }
}

extension WallpaperBrowserController: UIPageViewControllerDelegate {
    
}

extension WallpaperBrowserController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let indexOfCurrentVC = listOfVCs.firstIndex(of: viewController) else { return nil }
        
        if indexOfCurrentVC == 0 {
            return listOfVCs[listOfVCs.count - 1]
        } else {
            return listOfVCs[indexOfCurrentVC - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let indexOfCurrentVC = listOfVCs.firstIndex(of: viewController) else { return nil }
        
        if indexOfCurrentVC == listOfVCs.count - 1 {
            return listOfVCs[0]
        } else {
            return listOfVCs[indexOfCurrentVC + 1]
        }
    }
    
}

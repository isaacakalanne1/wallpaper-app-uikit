//
//  FilterNavigatorViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import UIKit

protocol WallpaperDelegate: AnyObject {
    func didChange(wallpaper: UIImage)
    func didApply(filter: Filter)
}

class FilterNavigatorViewController: UIPageViewController {
    
    let filterBrowserVC = FilterBrowserViewController()
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        
        view.backgroundColor = Color.secondary
        
        dataSource = self
        delegate = self
        
        setViewControllers([filterBrowserVC], direction: .forward, animated: true, completion: nil)
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(_ wallpaper: UIImage) {
        filterBrowserVC.updateWallpaper(wallpaper)
    }
    
}

extension FilterNavigatorViewController: UIPageViewControllerDelegate { }

extension FilterNavigatorViewController: UIPageViewControllerDataSource {
    
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

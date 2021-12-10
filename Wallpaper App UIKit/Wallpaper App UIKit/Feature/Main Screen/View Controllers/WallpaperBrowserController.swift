//
//  WallpaperBrowserController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 10/12/2021.
//

import UIKit

class WallpaperBrowserController: UIPageViewController {
    
    var listOfVCs: [UIViewController] = []
    var currentIndex: Int = 0
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let vc = UIViewController()
        vc.view.backgroundColor = .systemOrange
        
        dataSource = self
        delegate = self
        
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
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

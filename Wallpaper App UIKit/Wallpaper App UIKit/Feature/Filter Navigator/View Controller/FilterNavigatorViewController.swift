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
    
    var listOfVCs: [FilterBrowserViewController] = []
    var currentIndex: Int = 0
    let filterDelegate: FilterDelegate?
    
    init(filterDelegate: FilterDelegate?) {
        self.filterDelegate = filterDelegate
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        
        view.backgroundColor = Color.secondary
        
        dataSource = self
        delegate = self
        
        listOfVCs = [FilterBrowserViewController(delegate: self),
                     FilterBrowserViewController(delegate: self),
                     FilterBrowserViewController(delegate: self)]
        
        setViewControllers([listOfVCs[0]], direction: .forward, animated: true, completion: nil)
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(_ wallpaper: UIImage) {
        listOfVCs.forEach { vc in
            vc.updateWallpaper(wallpaper)
        }
    }
    
}

extension FilterNavigatorViewController: WallpaperDelegate {
    func didChange(wallpaper: UIImage) {
        
    }
    
    func didApply(filter: Filter) {
        
    }
}

extension FilterNavigatorViewController: FilterDelegate {
    func didSelectFilter(_ filter: Filter) {
        filterDelegate?.didSelectFilter(filter)
    }
}

extension FilterNavigatorViewController: UIPageViewControllerDelegate { }

extension FilterNavigatorViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? FilterBrowserViewController,
              let indexOfCurrentVC = listOfVCs.firstIndex(of: vc) else { return nil }
        currentIndex = indexOfCurrentVC
        
        if indexOfCurrentVC == 0 {
            return nil
        } else {
            return listOfVCs[indexOfCurrentVC - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? FilterBrowserViewController,
              let indexOfCurrentVC = listOfVCs.firstIndex(of: vc) else { return nil }
        currentIndex = indexOfCurrentVC
        
        if indexOfCurrentVC == listOfVCs.count - 1 {
            return nil
        } else {
            return listOfVCs[indexOfCurrentVC + 1]
        }
    }
}

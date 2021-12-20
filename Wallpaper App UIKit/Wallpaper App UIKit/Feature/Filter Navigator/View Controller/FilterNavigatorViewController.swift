//
//  FilterNavigatorViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import UIKit

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
        
        listOfVCs = [FilterBrowserViewController(delegate: self)]
        
        setViewControllers([listOfVCs[0]], direction: .forward, animated: true, completion: nil)
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateWallpaper(editedWallpaper: UIImage, originalWallpaper: UIImage) {
        listOfVCs.forEach { vc in
            vc.updateWallpaper(editedWallpaper: editedWallpaper, originalWallpaper: originalWallpaper)
        }
    }
    
    func deselectButtons() {
        listOfVCs.forEach { vc in
            vc.deselectButtons()
        }
    }
    
    func updateClearButtonSelection(isSelected: Bool) {
        listOfVCs.forEach { vc in
            vc.updateClearButtonSelection(isSelected: isSelected)
        }
    }
    
    func updateClearButtonVisibility(isWallpaperEdited: Bool) {
        listOfVCs.forEach { vc in
            vc.updateClearButtonVisibility(isHidden: !isWallpaperEdited)
        }
    }
    
    func unlock(filter: Filter?) {
        listOfVCs.forEach { vc in
            vc.unlock(filter: filter)
        }
    }
    
}

extension FilterNavigatorViewController: FilterDelegate {
    
    func didSelectFilter(_ filter: Filter?) {
        filterDelegate?.didSelectFilter(filter)
    }
    
    func didSelectClearButton() {
        filterDelegate?.didSelectClearButton()
    }
    
    func finishedFilteringWallpaper() {
        
    }
    
    func applyFilter() {
        filterDelegate?.applyFilter()
    }
    
    func cancelFilter() {
        
    }
    
    func clearAllFilters() {
        filterDelegate?.clearAllFilters()
    }
}

extension FilterNavigatorViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let pendingVC = pendingViewControllers.first as? FilterBrowserViewController,
              let indexOfCurrentVC = listOfVCs.firstIndex(of: pendingVC) else { return }
        currentIndex = indexOfCurrentVC
    }
}

extension FilterNavigatorViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? FilterBrowserViewController,
              let indexOfCurrentVC = listOfVCs.firstIndex(of: vc) else { return nil }
        
        if indexOfCurrentVC == 0 {
            return nil
        } else {
            guard listOfVCs.indices.contains(indexOfCurrentVC - 1) else { return nil }
            return listOfVCs[indexOfCurrentVC - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? FilterBrowserViewController,
              let indexOfCurrentVC = listOfVCs.firstIndex(of: vc) else { return nil }
        
        if indexOfCurrentVC == listOfVCs.count - 1 {
            return nil
        } else {
            guard listOfVCs.indices.contains(indexOfCurrentVC + 1) else { return nil }
            return listOfVCs[indexOfCurrentVC + 1]
        }
    }
}

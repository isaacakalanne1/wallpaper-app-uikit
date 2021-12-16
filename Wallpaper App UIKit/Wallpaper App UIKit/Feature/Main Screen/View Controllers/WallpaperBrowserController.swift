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
    
    let imgurApi = ImgurAPI()
    
    let wallpaperDelegate: WallpaperDelegate?
    let announcementDelegate: AnnouncementDelegate?
    
    init(wallpaperDelegate: WallpaperDelegate?, announcementDelegate: AnnouncementDelegate?) {
        self.wallpaperDelegate = wallpaperDelegate
        self.announcementDelegate = announcementDelegate
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
                
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    
                    data.links.forEach { link in
                        self?.listOfVCs.append(WallpaperViewController(link: link, wallpaperDelegate: self, announcementDelegate: self))
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
    
    func previewFilter(_ filter: Filter, sliderValue: Float) {
        guard let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.previewFilter(filter, sliderValue: sliderValue)
    }
    
    func applyFilter(_ filter: Filter) {
        guard let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.applyFilter(filter)
    }
    
    func cancelFilter() {
        guard let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.cancelFilter()
    }
    
    func clearAllFilters() {
        guard let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.clearAllFilters()
    }
    
    func saveWallpaperToPhotos() {
        guard let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.saveWallpaperToPhotos()
    }
    
}

extension WallpaperBrowserController: WallpaperDelegate {
    func didChange(wallpaper: UIImage) {
        wallpaperDelegate?.didChange(wallpaper: wallpaper)
    }
}

extension WallpaperBrowserController: AnnouncementDelegate {
    func displayAnnouncement(_ text: String) {
        announcementDelegate?.displayAnnouncement(text)
    }
}

extension WallpaperBrowserController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let pendingVC = pendingViewControllers.first,
              let indexOfCurrentVC = listOfVCs.firstIndex(of: pendingVC) else { return }
        currentIndex = indexOfCurrentVC
    }
}

extension WallpaperBrowserController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let indexOfCurrentVC = listOfVCs.firstIndex(of: viewController) else { return nil }
        
        let indexOfPreviousVC = indexOfCurrentVC == 0 ? listOfVCs.count - 1 : indexOfCurrentVC - 1
        
        return listOfVCs[indexOfPreviousVC]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let indexOfCurrentVC = listOfVCs.firstIndex(of: viewController) else { return nil }
        
        let indexOfNextVC = indexOfCurrentVC == listOfVCs.count - 1 ? 0 : indexOfCurrentVC + 1
        
        return listOfVCs[indexOfNextVC]
    }
    
}

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
    let filterDelegate: FilterDelegate?
    let announcementDelegate: AnnouncementDelegate?
    
    init(wallpaperDelegate: WallpaperDelegate?, filterDelegate: FilterDelegate?, announcementDelegate: AnnouncementDelegate?) {
        self.wallpaperDelegate = wallpaperDelegate
        self.filterDelegate = filterDelegate
        self.announcementDelegate = announcementDelegate
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        dataSource = self
        delegate = self
        
        // SAO wallpapers : zOcv3
        // Anime wallpapers : T6bjgLb
        imgurApi.downloadData(forHash: AppData.albumHash) { [weak self] result in
            switch result {
            case .success(let data):
                
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    
                    data.links.forEach { link in
                        self?.listOfVCs.append(WallpaperViewController(link: link,
                                                                       wallpaperDelegate: self,
                                                                       filterDelegate: self,
                                                                       announcementDelegate: self))
                    }
                    
                    if let vc = self?.listOfVCs[0] {
                        self?.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                print("Imgur Album Data download failed! Error is \(error)")
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func previewClearFilters() {
        guard listOfVCs.indices.contains(currentIndex),
              let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.previewClearFilters()
    }
    
    func previewFilter(_ filter: Filter, sliderValue: Float) {
        guard listOfVCs.indices.contains(currentIndex),
              let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.previewFilter(filter, sliderValue: sliderValue)
    }
    
    func applyFilter(_ filter: Filter) {
        guard listOfVCs.indices.contains(currentIndex),
              let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.applyFilter(filter)
    }
    
    func cancelPreviewedFilter() {
        guard listOfVCs.indices.contains(currentIndex),
              let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.cancelFilter()
    }
    
    func clearAllFilters() {
        guard listOfVCs.indices.contains(currentIndex),
              let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.clearAllFilters()
    }
    
    func saveWallpaperToPhotos(didWatchAd: Bool) {
        guard listOfVCs.indices.contains(currentIndex),
              let vc = listOfVCs[currentIndex] as? WallpaperViewController else { return }
        vc.saveWallpaperToPhotos(didWatchAd: didWatchAd)
    }
    
}

extension WallpaperBrowserController: WallpaperDelegate {
    func didChange(editedWallpaper: UIImage, originalWallpaper: UIImage, isWallpaperEdited: Bool) {
        wallpaperDelegate?.didChange(editedWallpaper: editedWallpaper, originalWallpaper: originalWallpaper, isWallpaperEdited: isWallpaperEdited)
    }
}

extension WallpaperBrowserController: FilterDelegate {
    
    func didSelectFilter(_ filter: Filter) {
        
    }
    
    func didSelectResetButton() {
        
    }
    
    func finishedFilteringWallpaper() {
        filterDelegate?.finishedFilteringWallpaper()
    }
    
    func applyFilter() {
        
    }
    
    func cancelFilter() {
        filterDelegate?.cancelFilter()
    }
}

extension WallpaperBrowserController: AnnouncementDelegate {
    func displayAnnouncement(_ text: String, secondAnnouncement: String?) {
        announcementDelegate?.displayAnnouncement(text, secondAnnouncement: secondAnnouncement)
    }
}

extension WallpaperBrowserController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = viewControllers?.first,
              let index = listOfVCs.firstIndex(of: vc) else { return }
        let previousVC = previousViewControllers.first as? WallpaperViewController
        previousVC?.resetEdit()
        currentIndex = index
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

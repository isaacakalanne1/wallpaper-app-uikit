//
//  ViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 30/11/2021.
//

import UIKit
import GoogleMobileAds

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
    lazy var tertiaryContainer = TertiaryContainer()
    lazy var secondaryButtonContainer = SecondaryButtonContainer(delegate: self,
                                                                 status: buttonStatus)
    
    let initialSliderValue: Float = 0.75
    lazy var sliderValue: Float = initialSliderValue
    
    lazy var slider = Slider(delegate: self, initialValue: sliderValue)
    
    var currentFilter: Filter?
    var buttonStatus: SecondaryButtonContainer.ButtonStatus = .hide
    
    let filterNavigatorView = UIView()
    let downloadButton = Button(style: .primary, title: "Download")
    
    lazy var filterNavigatorVC = FilterNavigatorViewController(filterDelegate: self)
    lazy var wallpaperBrowserVC = WallpaperBrowserController(wallpaperDelegate: self,
                                                             filterDelegate: self,
                                                             announcementDelegate: self)
    
    lazy var videoVC = VideoViewController(delegate: self, adDelegate: self)
    
    var rewardedAd: GADRewardedAd?
    let user = User()
    var points: Int {
        return user.points
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetFilterUnlocks()
        
        view.backgroundColor = Color.primary
        
        wallpaperBrowserView.translatesAutoresizingMaskIntoConstraints = false
        filterNavigatorView.translatesAutoresizingMaskIntoConstraints = false
        
        insert(filterNavigatorVC, into: filterNavigatorView)
        insert(wallpaperBrowserVC, into: wallpaperBrowserView)
        
        tertiaryContainer.isHidden = true
        
        downloadButton.addTarget(self, action: #selector(savePhotoToWallpapers), for: .touchUpInside)
        
        stackView.addArrangedSubview(wallpaperBrowserView)
        stackView.addArrangedSubview(tertiaryContainer)
        stackView.addArrangedSubview(secondaryButtonContainer)
        stackView.addArrangedSubview(slider)
        stackView.addArrangedSubview(filterNavigatorView)
        stackView.addArrangedSubview(downloadButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            
            wallpaperBrowserView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            wallpaperBrowserView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            tertiaryContainer.heightAnchor.constraint(equalToConstant: 45),
            tertiaryContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tertiaryContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            secondaryButtonContainer.heightAnchor.constraint(equalToConstant: 45),
            secondaryButtonContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            secondaryButtonContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            slider.heightAnchor.constraint(equalToConstant: 30),
            slider.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: margin),
            slider.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -margin),
            
            filterNavigatorView.heightAnchor.constraint(equalToConstant: 90),
            filterNavigatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            filterNavigatorView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            downloadButton.heightAnchor.constraint(equalToConstant: 60),
            downloadButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: margin),
            downloadButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -margin),
        ])
        
        loadNewAd()
    }
    
    func resetFilterUnlocks() {
        Filter.allCases.forEach { filter in
            if !filter.isUnlockedByDefault {
                UserDefaults.standard.set(false, forKey: filter.isUnlockedKey)
            }
        }
    }

}
extension MainViewController: AdDelegate {
    
    func loadNewAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313",
                           request: request, completionHandler: { [weak self] (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            } else {
                print("Rewarded ad loaded")
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.videoVC.updateVideo(ad)
        })
    }
    
}

protocol AdDelegate: AnyObject {
    func loadNewAd()
}

extension MainViewController: WallpaperDelegate {
    func didChange(editedWallpaper: UIImage, originalWallpaper: UIImage, isWallpaperEdited: Bool) {
        filterNavigatorVC.updateWallpaper(editedWallpaper: editedWallpaper,
                                          originalWallpaper: originalWallpaper)
        filterNavigatorVC.updateButtonVisibility(isWallpaperEdited: isWallpaperEdited)
    }
}

extension MainViewController: FilterDelegate {
    
    func didSelectFilter(_ filter: Filter) {
        currentFilter = filter
        
        if filter != .clear {
            sliderValue = initialSliderValue
            slider.value = sliderValue
        }
        
        if filter.isUnlocked {
            buttonStatus = .applyFilter
            tertiaryContainer.displayPermanentAnnouncement(nil)
        } else {
            displayUnlockAnnouncement()
        }
        
        wallpaperBrowserVC.previewFilter(filter, sliderValue: sliderValue)
        secondaryButtonContainer.toggleButtons(buttonStatus)
        secondaryButtonContainer.updatePrimaryButtonInteraction(canInteract: filter == .clear)
    }
    
    func finishedFilteringWallpaper() {
        secondaryButtonContainer.updatePrimaryButtonInteraction(canInteract: true)
    }
    
    func applyFilter() {
        guard let filter = currentFilter else { return }
        secondaryButtonContainer.displayAnnouncement(filter.applyFilterAnnouncement)
        
        wallpaperBrowserVC.applyFilter(filter)
        
        filterNavigatorVC.deselectButtons()
        secondaryButtonContainer.toggleButtons(.hide)
        currentFilter = nil
    }
    
    func cancelFilter() {
        wallpaperBrowserVC.cancelPreviewedFilter()
        
        filterNavigatorVC.deselectButtons()
        tertiaryContainer.displayPermanentAnnouncement(nil)
        secondaryButtonContainer.toggleButtons(.hide)
        currentFilter = nil
    }
    
    func clearAllFilters() {
        wallpaperBrowserVC.clearAllFilters()
    }
    
    func displayUnlockAnnouncement() {
        guard let filter = currentFilter else { return }
        let pointsNeededToUnlock = filter.costToUnlock - points
        switch pointsNeededToUnlock {
        case 1:
            buttonStatus = .getPoints
            tertiaryContainer.displayPermanentAnnouncement("You need 1 more point to unlock")
        case 2...:
            buttonStatus = .getPoints
            tertiaryContainer.displayPermanentAnnouncement("You need \(pointsNeededToUnlock) more points to unlock")
        default:
            buttonStatus = .unlockFilter(filter: filter)
            tertiaryContainer.displayPermanentAnnouncement("You have \(points) points")
        }
    }
    
    @objc func savePhotoToWallpapers() {
        wallpaperBrowserVC.saveWallpaperToPhotos()
    }
}

extension MainViewController: ButtonDelegate {
    func primaryButtonPressed(status: SecondaryButtonContainer.ButtonStatus) {
        switch status {
        case .getPoints:
            videoVC.updateVideo(rewardedAd)
            self.navigationController?.pushViewController(videoVC, animated: true)
        case .unlockFilter:
            if let key = currentFilter?.isUnlockedKey,
               let cost = currentFilter?.costToUnlock {
                user.spendPoints(cost) { [weak self] res in
                    switch res {
                    case .success:
                        UserDefaults.standard.set(true, forKey: key)
                        self?.filterNavigatorVC.unlock(filter: self?.currentFilter)
                        self?.secondaryButtonContainer.toggleButtons(.applyFilter)
                        self?.tertiaryContainer.displayPermanentAnnouncement(nil)
                        self?.secondaryButtonContainer.displayAnnouncement("Unlocked filter")
                    case .failure:
                        self?.tertiaryContainer.displayAnnouncement("Failed to unlock filter")
                    }
                }
            }
        case .applyFilter:
            applyFilter()
        default:
            break
        }
    }
    
    func secondaryButtonPressed(status: SecondaryButtonContainer.ButtonStatus) {
        switch status {
        case .earn1Point:
            displayUnlockAnnouncement()
            secondaryButtonContainer.toggleButtons(buttonStatus)
        default:
            cancelFilter()
        }
    }
}

extension MainViewController: SliderDelegate {
    func didChangeValue(_ value: Float) {
        sliderValue = value
        guard let filter = currentFilter else { return }
        
        wallpaperBrowserVC.previewFilter(filter, sliderValue: value)
        secondaryButtonContainer.toggleButtons(.applyFilter)
        secondaryButtonContainer.updatePrimaryButtonInteraction(canInteract: filter == .clear)
    }
}

extension MainViewController: AnnouncementDelegate {
    func displayAnnouncement(_ text: String) {
        secondaryButtonContainer.displayAnnouncement(text)
    }
}

extension MainViewController: GADFullScreenContentDelegate { }

extension UIViewController {
    
    func insert(_ viewController: UIViewController, into view: UIView) {
        viewController.view.frame = view.bounds
        self.addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
}


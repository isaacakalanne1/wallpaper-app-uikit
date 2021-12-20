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
    lazy var mainButtonContainer = MainButtonContainer(downloadDelegate: self, announcementDelegate: self)
    
    lazy var filterNavigatorVC = FilterNavigatorViewController(filterDelegate: self)
    lazy var wallpaperBrowserVC = WallpaperBrowserController(wallpaperDelegate: self,
                                                             filterDelegate: self,
                                                             announcementDelegate: self)
    
    var rewardedAd: GADRewardedAd?
    let user = User()
    var points: Int {
        return user.points
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.primary
        
        wallpaperBrowserView.translatesAutoresizingMaskIntoConstraints = false
        filterNavigatorView.translatesAutoresizingMaskIntoConstraints = false
        
        insert(filterNavigatorVC, into: filterNavigatorView)
        insert(wallpaperBrowserVC, into: wallpaperBrowserView)
        
        tertiaryContainer.isHidden = true
        
        stackView.addArrangedSubview(wallpaperBrowserView)
        stackView.addArrangedSubview(tertiaryContainer)
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
            
            mainButtonContainer.heightAnchor.constraint(equalToConstant: 60),
            mainButtonContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: margin),
            mainButtonContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -margin),
        ])
        
        loadRewardedAd()
    }
    
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-8123415297019784/9501821136",
                           request: request, completionHandler: { (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            } else {
                print("Rewarded ad loaded")
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        })
    }

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
        
        if filter.isLockedByDefault {
            
            let pointsNeededToUnlock = filter.costToUnlock - points
            switch pointsNeededToUnlock {
            case 1:
                buttonStatus = .getPoints
                tertiaryContainer.displayAnnouncement("You need 1 more point to unlock")
            case 2...:
                buttonStatus = .getPoints
                tertiaryContainer.displayAnnouncement("You need \(pointsNeededToUnlock) more points to unlock")
            default:
                buttonStatus = .unlockFilter
                tertiaryContainer.displayAnnouncement("You have \(points) points")
            }
        } else {
            buttonStatus = .applyFilter
            tertiaryContainer.displayAnnouncement(nil)
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
        tertiaryContainer.displayAnnouncement(nil)
        secondaryButtonContainer.toggleButtons(.hide)
        currentFilter = nil
    }
    
    func clearAllFilters() {
        wallpaperBrowserVC.clearAllFilters()
    }
}

extension MainViewController: ButtonDelegate {
    func primaryButtonPressed() {
        if currentFilter?.isLockedByDefault == true {
            let newViewController = VideoViewController()
            self.navigationController?.pushViewController(newViewController, animated: true)
        } else {
            applyFilter()
        }
    }
    
    func secondaryButtonPressed() {
        cancelFilter()
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

extension MainViewController: DownloadDelegate {
    func saveWallpaperToPhotos() {
        wallpaperBrowserVC.saveWallpaperToPhotos()
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


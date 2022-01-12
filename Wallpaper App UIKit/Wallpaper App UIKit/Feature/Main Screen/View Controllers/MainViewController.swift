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
    lazy var secondaryButtonContainer = SecondaryButtonContainer(delegate: self,
                                                                 status: buttonStatus)
    
    let initialSliderValue: Float = 0.75
    lazy var sliderValue: Float = initialSliderValue
    
    lazy var slider = Slider(delegate: self, initialValue: sliderValue)
    
    var currentFilter: Filter?
    var buttonStatus: SecondaryButtonContainer.ButtonStatus = .hide
    
    let filterNavigatorView = UIView()
    let downloadButton = Button(style: .primary, title: "Watch video to Download")
    
    lazy var filterNavigatorVC = FilterNavigatorViewController(filterDelegate: self)
    lazy var wallpaperBrowserVC = WallpaperBrowserController(wallpaperDelegate: self,
                                                             filterDelegate: self,
                                                             announcementDelegate: self)
    
    
    var adStatus: AdStatus = .loading
    
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.primary
        
        wallpaperBrowserView.translatesAutoresizingMaskIntoConstraints = false
        filterNavigatorView.translatesAutoresizingMaskIntoConstraints = false
        
        insert(filterNavigatorVC, into: filterNavigatorView)
        insert(wallpaperBrowserVC, into: wallpaperBrowserView)
        
        downloadButton.addTarget(self, action: #selector(presentVideo), for: .touchUpInside)
        
        stackView.addArrangedSubview(wallpaperBrowserView)
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
    
    func loadNewAd() {
        let request = GADRequest()
        adStatus = .loading
        GADRewardedAd.load(withAdUnitID: AppData.videoAdId,
                           request: request, completionHandler: { [weak self] (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                self?.adStatus = .noAdToShow
                return
            } else {
                self?.adStatus = .loaded
                print("Rewarded ad loaded")
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
        })
    }

}

enum AdStatus {
    
    case noAdToShow, loading, loaded
    
    var announcementText: String? {
        switch self {
        case .noAdToShow:
            return "Videos will be ready in a few days"
        case .loading:
            return "Loading video"
        case .loaded:
            return nil
        }
    }
}

extension MainViewController: WallpaperDelegate {
    func didChange(editedWallpaper: UIImage, originalWallpaper: UIImage, isWallpaperEdited: Bool) {
        filterNavigatorVC.updateWallpaper(editedWallpaper: editedWallpaper,
                                          originalWallpaper: originalWallpaper)
        filterNavigatorVC.updateResetButtonVisibility(isWallpaperEdited: isWallpaperEdited)
    }
}

extension MainViewController: FilterDelegate {
    
    func didSelectFilter(_ filter: Filter) {
        currentFilter = filter
        
        if filter != .reset {
            sliderValue = initialSliderValue
            slider.value = sliderValue
        }
        
        buttonStatus = .applyFilter
        
        filterNavigatorVC.updateResetButtonSelection(isSelected: false)
        if filter != .reset {
            wallpaperBrowserVC.previewFilter(filter, sliderValue: sliderValue)
            secondaryButtonContainer.updatePrimaryButtonInteraction(canInteract: false)
        }
        secondaryButtonContainer.toggleButtons(buttonStatus)
    }
    
    func didSelectResetButton() {
        wallpaperBrowserVC.previewClearFilters()
        secondaryButtonContainer.toggleButtons(buttonStatus)
    }
    
    func finishedFilteringWallpaper() {
        secondaryButtonContainer.updatePrimaryButtonInteraction(canInteract: true)
    }
    
    func applyFilter() {
        guard let filter = currentFilter else { return }
        
        secondaryButtonContainer.displayAnnouncement(filter.applyFilterAnnouncement)
        
        wallpaperBrowserVC.applyFilter(filter)
        
        filterNavigatorVC.deselectButtons()
        filterNavigatorVC.updateResetButtonVisibility(isWallpaperEdited: true)
        secondaryButtonContainer.toggleButtons(.hide)
        currentFilter = nil
    }
    
    func cancelFilter() {
        wallpaperBrowserVC.cancelPreviewedFilter()
        
        filterNavigatorVC.deselectButtons()
        secondaryButtonContainer.toggleButtons(.hide)
        currentFilter = nil
    }
    
    func clearAllFilters() {
        filterNavigatorVC.deselectButtons()
        filterNavigatorVC.updateResetButtonVisibility(isWallpaperEdited: false)
        wallpaperBrowserVC.clearAllFilters()
        secondaryButtonContainer.toggleButtons(.hide)
        currentFilter = nil
    }
    
    @objc private func presentVideo() {
        switch adStatus {
        case .loaded:
            if let ad = rewardedAd {
                ad.present(fromRootViewController: self,
                           userDidEarnRewardHandler: {
                    self.wallpaperBrowserVC.saveWallpaperToPhotos(didWatchAd: true)
                    self.loadNewAd()
                })
            }
            loadNewAd()
        case .loading:
            if let text = adStatus.announcementText {
                self.displayAnnouncement(text, secondAnnouncement: nil)
            }
        case .noAdToShow:
            self.wallpaperBrowserVC.saveWallpaperToPhotos(didWatchAd: false)
        }
    }
}

extension MainViewController: ButtonDelegate {
    func primaryButtonPressed(status: SecondaryButtonContainer.ButtonStatus) {
        switch status {
        case .applyFilter:
            if currentFilter == .reset {
                clearAllFilters()
            } else {
                applyFilter()
            }
        default:
            break
        }
    }
    
    func primaryButtonPressedWhileDisabled(status: SecondaryButtonContainer.ButtonStatus) {
        
    }
    
    func secondaryButtonPressed(status: SecondaryButtonContainer.ButtonStatus) {
        switch status {
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
        secondaryButtonContainer.toggleButtons(buttonStatus)
        secondaryButtonContainer.updatePrimaryButtonInteraction(canInteract: false)
    }
}

extension MainViewController: AnnouncementDelegate {
    func displayAnnouncement(_ text: String, secondAnnouncement: String?) {
        if let secondText = secondAnnouncement {
            secondaryButtonContainer.displayAnnouncement(text) {
                self.secondaryButtonContainer.displayAnnouncement(secondText)
            }
        } else {
            secondaryButtonContainer.displayAnnouncement(text)
        }
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


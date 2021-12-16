//
//  WallpaperViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 10/12/2021.
//

import UIKit

protocol WallpaperDelegate: AnyObject {
    func didChange(wallpaper: UIImage, isWallpaperEdited: Bool)
}

class WallpaperViewController: UIViewController {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.color = Color.accent
        return spinner
    }()
    
    let imgurApi = ImgurAPI()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var originalWallpaper: UIImage?
    var wallpaperToEdit: UIImage?
    
    let link: String
    let wallpaperDelegate: WallpaperDelegate?
    let filterDelegate: FilterDelegate?
    let announcementDelegate: AnnouncementDelegate?
    
    init(link: String, wallpaperDelegate: WallpaperDelegate?, filterDelegate: FilterDelegate?, announcementDelegate: AnnouncementDelegate?) {
        self.link = link
        self.wallpaperDelegate = wallpaperDelegate
        self.filterDelegate = filterDelegate
        self.announcementDelegate = announcementDelegate
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = originalWallpaper {
            let isWallpaperEdited = originalWallpaper != wallpaperToEdit
            imageView.image = isWallpaperEdited ? wallpaperToEdit : originalWallpaper
            wallpaperDelegate?.didChange(wallpaper: image, isWallpaperEdited: isWallpaperEdited)
        } else {
            imgurApi.downloadImage(from: link) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.wallpaperDelegate?.didChange(wallpaper: image, isWallpaperEdited: false)
                        
                        self?.originalWallpaper = image
                        self?.wallpaperToEdit = image
                        self?.imageView.image = image
                        
                        self?.spinner.isHidden = true
                    }
                case .failure(let error):
                    print("Downloading image error! Error is \(error)")
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        filterDelegate?.cancelFilter()
        imageView.image = wallpaperToEdit
    }
    
    func applyFilter(_ filter: Filter) {
        if filter == .clear {
            clearAllFilters()
        } else {
            wallpaperToEdit = imageView.image
            guard let wallpaper = wallpaperToEdit else { return }
            wallpaperDelegate?.didChange(wallpaper: wallpaper, isWallpaperEdited: true)
        }
    }
    
    func cancelFilter() {
        imageView.image = wallpaperToEdit
    }
    
    func clearAllFilters() {
        wallpaperToEdit = originalWallpaper
        imageView.image = originalWallpaper
        guard let wallpaper = originalWallpaper else { return }
        wallpaperDelegate?.didChange(wallpaper: wallpaper, isWallpaperEdited: false)
    }
    
    func previewFilter(_ filter: Filter, sliderValue: Float) {
        
        if filter == .clear {
            imageView.image = originalWallpaper
        } else {
            
            DispatchQueue.global(qos: .userInitiated).async {
                let editedImage = ImageEditor.filterImage(self.wallpaperToEdit,
                                                          with: filter,
                                                          sliderValue: sliderValue)

                DispatchQueue.main.async {
                    if let image = editedImage {
                        self.imageView.image = image
                    } else {
                        self.announcementDelegate?.displayAnnouncement("Couldn't apply filter")
                    }
                }
            }
        }
    }
    
    func saveWallpaperToPhotos() {
        guard let image = wallpaperToEdit else { return }
        let imageSaver = ImageSaver(delegate: self)
        imageSaver.saveWallpaperToPhotos(image: image)
    }
    
}

extension WallpaperViewController: AnnouncementDelegate {
    func displayAnnouncement(_ text: String) {
        announcementDelegate?.displayAnnouncement(text)
    }
}

//
//  WallpaperViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 10/12/2021.
//

import UIKit

protocol WallpaperDelegate: AnyObject {
    func didChange(wallpaper: UIImage)
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
    let announcementDelegate: AnnouncementDelegate?
    
    init(link: String, wallpaperDelegate: WallpaperDelegate?, announcementDelegate: AnnouncementDelegate?) {
        self.link = link
        self.wallpaperDelegate = wallpaperDelegate
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
            wallpaperDelegate?.didChange(wallpaper: image)
        } else {
            imgurApi.downloadImage(from: link) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.wallpaperDelegate?.didChange(wallpaper: image)
                        
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
    
    func applyFilter() {
        wallpaperToEdit = imageView.image
        guard let wallpaper = wallpaperToEdit else { return }
        wallpaperDelegate?.didChange(wallpaper: wallpaper)
    }
    
    func cancelFilter() {
        imageView.image = wallpaperToEdit
    }
    
    func clearAllFilters() {
        wallpaperToEdit = originalWallpaper
        imageView.image = originalWallpaper
        guard let wallpaper = originalWallpaper else { return }
        wallpaperDelegate?.didChange(wallpaper: wallpaper)
    }
    
    func previewFilter(_ filter: Filter, sliderValue: Float) {
        let context = CIContext(options: nil)
        
        guard let imputImage = wallpaperToEdit,
              let beginImage = CIImage(image: imputImage) else { return }
        
        let currentFilter = filter.createCIFilter(inputImage: beginImage,
                                                  sliderValue: sliderValue)
        
        guard let output = currentFilter?.outputImage,
              let cgimg = context.createCGImage(output, from: output.extent) else { return }
        
        let processedImage = UIImage(cgImage: cgimg)
        imageView.image = processedImage
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

//
//  WallpaperViewController.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 10/12/2021.
//

import UIKit

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
    
    let link: String
    let delegate: WallpaperDelegate?
    
    init(link: String, delegate: WallpaperDelegate? = nil) {
        self.link = link
        self.delegate = delegate
        
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
        
        imgurApi.downloadImage(from: link) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.delegate?.didChange(wallpaper: image)
                    self?.imageView.image = image
                    self?.spinner.isHidden = true
                }
            case .failure(let error):
                print("Downloading image error! Error is \(error)")
            }
        }
    }
    
    func applyFilter(_ filter: Filter) {
        guard let imputImage = imageView.image else { return }
        let context = CIContext(options: nil)
        
        let currentFilter = CircularBokeh()
        let beginImage = CIImage(image: imputImage)
        currentFilter.inputImage = beginImage
//        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
//        currentFilter.setValue(0.5, forKey: kCIInputIntensityKey)
        
        guard let output = currentFilter.outputImage,
              let cgimg = context.createCGImage(output, from: output.extent) else { return }
        let processedImage = UIImage(cgImage: cgimg)
        imageView.image = processedImage
        delegate?.didChange(wallpaper: processedImage)
    }
    
}

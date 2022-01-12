//
//  ImageSaver.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 16/12/2021.
//

import UIKit

class ImageSaver: NSObject {
    
    let delegate: AnnouncementDelegate?
    var didWatchAd: Bool = true
    
    init(delegate: AnnouncementDelegate?) {
        self.delegate = delegate
    }
    func saveWallpaperToPhotos(image: UIImage, didWatchAd: Bool) {
        self.didWatchAd = didWatchAd
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let secondAnnouncement = didWatchAd ? nil : "Videos will be ready in a few days"
        delegate?.displayAnnouncement("Downloaded wallpaper", secondAnnouncement: secondAnnouncement)
    }
}

//
//  ImageSaver.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 16/12/2021.
//

import UIKit

class ImageSaver: NSObject {
    
    let delegate: AnnouncementDelegate?
    
    init(delegate: AnnouncementDelegate?) {
        self.delegate = delegate
    }
    func saveWallpaperToPhotos(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        delegate?.displayAnnouncement("Downloaded wallpaper")
    }
}

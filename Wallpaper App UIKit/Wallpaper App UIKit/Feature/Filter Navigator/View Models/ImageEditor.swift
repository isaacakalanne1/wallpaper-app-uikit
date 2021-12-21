//
//  ImageEditor.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 16/12/2021.
//

import UIKit

struct ImageEditor {
    
    static let context = CIContext(options: nil)
    
    func filterImage(_ image: UIImage?, with filter: Filter, sliderValue: Float) -> UIImage? {
        
        guard let imputImage = image,
              let beginImage = CIImage(image: imputImage) else { return nil }
        
        let currentFilter = filter.createCIFilter(inputImage: beginImage,
                                                  sliderValue: sliderValue)
        
        guard let output = currentFilter?.outputImage,
              let cgimg = ImageEditor.context.createCGImage(output, from: output.extent) else { return nil }
        
        let processedImage = UIImage(cgImage: cgimg)
        
        return processedImage
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

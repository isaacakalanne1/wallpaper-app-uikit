//
//  ImageEditor.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 16/12/2021.
//

import UIKit

struct ImageEditor {
    static func filterImage(_ image: UIImage?, with filter: Filter, sliderValue: Float) -> UIImage? {
        let context = CIContext(options: nil)
        
        guard let imputImage = image,
              let beginImage = CIImage(image: imputImage) else { return nil }
        
        let currentFilter = filter.createCIFilter(inputImage: beginImage,
                                                  sliderValue: sliderValue)
        
        guard let output = currentFilter?.outputImage,
              let cgimg = context.createCGImage(output, from: output.extent) else { return nil }
        
        let processedImage = UIImage(cgImage: cgimg)
        
        return processedImage
    }
}

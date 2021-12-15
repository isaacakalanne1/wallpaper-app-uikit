//
//  Filter.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import Foundation
import CoreImage
import UIKit

enum Filter: String, CaseIterable {
    case _super, leet, dope, high, tight, live, epic, sure, wow, fry, moon, good, zoom, lay, whoosh
    
    var title: String {
        switch self {
        case ._super:
            return "Super"
        default:
            return rawValue.prefix(1).capitalized + rawValue.dropFirst()
        }
    }
    
    func createCIFilter(inputImage: CIImage, sliderValue: Float) -> CIFilter {
        switch self {
        case ._super:
            let filter = CMYKLevels()
            filter.inputImage = inputImage
            return filter
        case .leet:
            let filter = KuwaharaFilter()
            filter.inputImage = inputImage
            return filter
        case .dope:
            let filter = CircularBokeh()
            filter.inputBlurRadius = CGFloat(5*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .high:
            let filter = PseudoColor()
            filter.inputImage = inputImage
            return filter
        case .tight:
            let filter = AdvancedMonochrome()
            filter.inputImage = inputImage
            return filter
        case .live:
            let filter = Scatter()
            filter.inputImage = inputImage
            return filter
        case .epic:
            let filter = ScatterWarp()
            filter.inputImage = inputImage
            return filter
        case .sure:
            let filter = ContrastStretch()
            filter.inputImage = inputImage
            return filter
        case .wow:
            let filter = TransverseChromaticAberration()
            filter.inputImage = inputImage
            return filter
        case .fry:
            let filter = HomogeneousColorBlur()
            filter.inputImage = inputImage
            return filter
        case .moon:
            let filter = PolarPixellate()
            filter.inputImage = inputImage
            return filter
        case .good:
            let filter = MultiBandHSV()
            filter.inputImage = inputImage
            return filter
        case .zoom:
            let filter = CompoundEye()
            filter.inputImage = inputImage
            return filter
        case .lay:
            let filter = BayerDitherFilter()
            filter.inputImage = inputImage
            return filter
        case .whoosh:
            let filter = CarnivalMirror()
            filter.inputImage = inputImage
            return filter
        }
    }
}

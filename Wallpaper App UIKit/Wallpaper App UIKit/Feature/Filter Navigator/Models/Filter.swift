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
    case clear, _super, leet, dope, yoyo, tight, live, epic, sure, wow, fry, moon, good, zoom, lay, whoosh
    
    var title: String {
        switch self {
        case ._super:
            return "Super"
        default:
            return rawValue.prefix(1).capitalized + rawValue.dropFirst()
        }
    }
    
    var applyFilterAnnouncement: String {
        switch self {
        case .clear:
            return "Cleared filters"
        default:
            return "Applied \(title)"
        }
    }
    
    func createCIFilter(inputImage: CIImage, sliderValue: Float) -> CIFilter? {
        switch self {
        case .clear:
            return nil
        case ._super:
            let filter = TransverseChromaticAberration()
            filter.inputBlur = CGFloat(20*sliderValue)
            filter.inputFalloff = CGFloat(0.4*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .leet:
            let filter = KuwaharaFilter()
            filter.inputRadius = CGFloat(20*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .dope:
            let filter = CircularBokeh()
            filter.inputBokehRadius = CGFloat(30*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .yoyo:
            let filter = PseudoColor()
            filter.inputSmoothness = CGFloat(3*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .tight:
            let filter = AdvancedMonochrome()
            filter.inputClamp = CGFloat(2*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .live:
            let filter = Scatter()
            filter.inputScatterRadius = CGFloat(50*sliderValue)
            filter.inputScatterSmoothness = CGFloat(2*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .epic:
            let filter = ScatterWarp()
            filter.inputScatterRadius = CGFloat(35*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .sure:
            let filter = TechnicolorFilter()
            filter.inputAmount = CGFloat(5*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .wow:
            let filter = VHSTrackingLines()
            filter.inputTime = CGFloat(10*sliderValue)
            filter.inputSpacing = CGFloat(50*sliderValue)
            filter.inputStripeHeight = CGFloat(0.5*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .fry:
            let filter = HomogeneousColorBlur()
            filter.inputColorThreshold = CGFloat(0.4*sliderValue)
            filter.inputRadius = CGFloat(20*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .moon:
            let filter = PolarPixellate()
            filter.inputPixelArc = CGFloat((Float.pi / 15)*sliderValue)
            filter.inputPixelLength = CGFloat(50*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .good:
            let filter = StarBurstFilter()
            filter.inputRadius = CGFloat(25*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .zoom:
            let filter = CompoundEye()
            filter.inputWidth = CGFloat(100*sliderValue)
            filter.inputBend = CGFloat(10*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .lay:
            let filter = EightBit()
            filter.inputPaletteIndex = CGFloat(4*sliderValue)
            filter.inputScale = CGFloat(8*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .whoosh:
            let filter = CarnivalMirror()
            filter.inputHorizontalWavelength = CGFloat(10*sliderValue)
            filter.inputHorizontalAmount = CGFloat(20*sliderValue)
            filter.inputVerticalWavelength = CGFloat(10*sliderValue)
            filter.inputVerticalAmount = CGFloat(20*sliderValue)
            filter.inputImage = inputImage
            return filter
        }
    }
}

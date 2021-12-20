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
    case clear, _super, leet, dope, yoyo, tight, sure, wow, fry, moon, good, live, epic, zoom, lay, whoosh, storm, hay, rope, fast
    
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
    
    var filterButtonPreviewSliderValue: Float {
        switch self {
        case ._super, .zoom, .wow, .whoosh:
            return 0.3
        default:
            return 0.75
        }
    }
    
    var isUnlockedKey: String { return "\(title)IsUnlocked"}
    
    var isUnlockedByDefault: Bool {
        switch self {
        case .clear, ._super, .leet, .dope, .yoyo, .tight, .sure:
            return true
        case .wow, .fry, .moon, .good, .live, .epic, .zoom, .lay, .whoosh, .storm, .hay, .rope, .fast:
            return false
        }
    }
    
    var isUnlocked: Bool {
        if isUnlockedByDefault {
            return true
        } else {
            return UserDefaults.standard.bool(forKey: isUnlockedKey)
        }
    }
    
    var costToUnlock: Int {
        return 4
    }
    
    func createCIFilter(inputImage: CIImage, sliderValue: Float) -> CIFilter? {
        switch self {
        case .clear:
            return nil
        case ._super:
            let filter = TransverseChromaticAberration()
            filter.inputBlur = CGFloat(50*sliderValue)
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
        case .storm:
            let filter = DifferenceOfGaussians()
            filter.inputSigma0 = CGFloat(0.75*sliderValue)
            filter.inputSigma1 = CGFloat(3.25*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .hay:
            let filter = MercurializeFilter()
            filter.inputEdgeThickness = CGFloat(5*sliderValue)
            filter.inputScale = CGFloat(10*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .rope:
            let filter = SmoothThreshold()
            filter.inputEdgeO = CGFloat(0.25*sliderValue)
            filter.inputEdge1 = CGFloat(0.75*sliderValue)
            filter.inputImage = inputImage
            return filter
        case .fast:
            let filter = TechnicolorFilter()
            filter.inputAmount = CGFloat(1*sliderValue)
            filter.inputImage = inputImage
            return filter
        }
    }
}

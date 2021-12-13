//
//  FilterData.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import Foundation

struct FilterData {
    
    static let allFilters: [Filter] = {
        var listOfFilters: [Filter] = []
        
        FilterType.allCases.forEach { type in
            listOfFilters.append(Filter(type: type, isPreviewing: false))
        }
        
        return listOfFilters
    }()
}

//
//  FilterData.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import Foundation

struct FilterData {
    
    static let listOfFilters: [Filter] = {
        var _listOfFilters: [Filter] = []
        
        FilterType.allCases.forEach { type in
            _listOfFilters.append(Filter(type: type, isPreviewing: false))
        }
        
        return _listOfFilters
    }()
}

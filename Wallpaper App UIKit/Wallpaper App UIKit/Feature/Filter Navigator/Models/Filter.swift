//
//  Filter.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 13/12/2021.
//

import Foundation

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
}

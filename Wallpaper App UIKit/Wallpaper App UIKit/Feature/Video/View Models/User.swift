//
//  User.swift
//  Wallpaper App UIKit
//
//  Created by iakalann on 20/12/2021.
//

import Foundation

struct User {
    
    var points: Int {
        return UserDefaults.standard.integer(forKey: "Points")
    }
    
    func spendPoints(_ p: Int) -> Result<Int, Error> {
        var currentPoints = points
        if currentPoints > p {
            currentPoints -= p
            UserDefaults.standard.set(currentPoints, forKey: "Points")
            return .success(currentPoints)
        } else {
            return .failure("")
        }
    }
    
    func savePoints(_ p: Int) {
        var currentPoints = points
        currentPoints += p
        UserDefaults.standard.set(currentPoints, forKey: "Points")
    }
}

//
//  mostRecentTwitterSearchesDataSource.swift
//  Smashtag
//
//  Created by Joe Isaacs on 24/09/2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

class mostRecentTwitterSearchesDataSource {
    
    private static let defaults = NSUserDefaults.standardUserDefaults()
    
    private struct Constant {
        static let mostRecentSearchHistory = "mostRecentTwitterSearchesDataSource.mostRecentSearchHistory"
    }
    
    private(set) static var mostRecentTwitterSearches: [String] {
        get {
            return defaults.objectForKey(Constant.mostRecentSearchHistory) as? [String] ?? []
        }
        set {
            print(newValue)
            defaults.setObject(newValue, forKey: Constant.mostRecentSearchHistory)
        }
    }
    
    static func appendValue(string: String) {
        var newArray = mostRecentTwitterSearches
        if let index = newArray.indexOf(string) {
            newArray.removeAtIndex(index)
        }
        newArray.insert(string, atIndex: 0)
        mostRecentTwitterSearches = newArray
    }
}
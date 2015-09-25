//
//  mostRecentTwitterSearchesDataSource.swift
//  Smashtag
//
//  Created by Joe Isaacs on 24/09/2015.
//  Copyright © 2015 Stanford University. All rights reserved.
//

import Foundation

class MostRecentTwitterSearchesDataSource {
    
    private static let defaults = NSUserDefaults.standardUserDefaults()
    
    private struct Constant {
        static let mostRecentSearchHistory = "mostRecentTwitterSearchesDataSource.mostRecentSearchHistory"
    }
    
    private(set) static var mostRecentTwitterSearches: [String] {
        get {
            return defaults.objectForKey(Constant.mostRecentSearchHistory) as? [String] ?? []
        }
        set {
            defaults.setObject(newValue, forKey: Constant.mostRecentSearchHistory)
        }
    }
    
    static func deleteRow (row: Int) {
        var newArray = mostRecentTwitterSearches
        newArray.removeAtIndex(row)
        mostRecentTwitterSearches = newArray
    }
    
    static func appendValue(string: String) {
        var newArray = mostRecentTwitterSearches
        newArray = newArray.filter { $0 != string }
        newArray.insert(string, atIndex: 0)
        mostRecentTwitterSearches = newArray
    }
}
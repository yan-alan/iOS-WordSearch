//
//  Score.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import Foundation

/// A score consists of a person and their score
struct Score {
    /// The name of the person who got the score
    var name: String
    /// The score
    var score: Int
    
    init(_ name: String, _ score: Int) {
        self.name = name
        self.score = score
    }
}

//
//  Line.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-09.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import Foundation

/// Represents a line from one index to another
struct Line {
    /// Start of line
    var startIndex: Int
    /// End of line
    var endIndex: Int

    init(_ startIndex: Int, _ endIndex: Int) {
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
}


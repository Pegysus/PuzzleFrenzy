//
//  CollectionExt.swift
//  PuzzleFrenzy
//
//  Created by Penelope on 8/27/21.
//

import Foundation

extension Collection {
    
    /// Returns the element at the spcified index if it is within bounds, otherwise nil
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}

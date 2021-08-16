//
//  MinesweeperTile.swift
//  PuzzleFrenzy
//
//  Created by Max Yeh on 8/11/21.
//

import Foundation
import SpriteKit

class MSTile: SKSpriteNode {
    
    var isBomb: Bool
    var isRevealed: Bool
    var isFlagged: Bool
    var row: Int
    var col: Int
    
    
    init() {
        
        self.isBomb = false
        self.isRevealed = false
        self.isFlagged = false
        self.row = 0
        self.col = 0
        
        // gonna add image for the image of the unrevealed tile and use that
        let texture = SKTexture(imageNamed: "MSTileImage")
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        
    }
    
    init(row: Int, col: Int) {
        
        self.isBomb = false
        self.isRevealed = false
        self.isFlagged = false
        self.row = row
        self.col = col
        
        let texture = SKTexture(imageNamed: "MSTileImage")
        super.init(texture: texture, color: UIColor.white, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented yet")
   }
}

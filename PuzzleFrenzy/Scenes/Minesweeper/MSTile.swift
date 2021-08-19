//
//  MinesweeperTile.swift
//  PuzzleFrenzy
//
//  Created by Max Yeh on 8/11/21.
//

import Foundation
import SpriteKit

class MSTile: SKSpriteNode {
    
    /* Properties */
    var isMine: Bool
    var isRevealed: Bool
    var isFlagged: Bool
    var row: Int
    var col: Int
    var adjacentMines: Int
    
    /* Constructors */
    init() {
        
        self.isMine = false
        self.isRevealed = false
        self.isFlagged = false
        self.row = 0
        self.col = 0
        self.adjacentMines = 0
        
        let texture = SKTexture(imageNamed: "MSTileImage")
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        
    }
    
    init(row: Int, col: Int) { // If given row and col values
        
        self.isMine = false
        self.isRevealed = false
        self.isFlagged = false
        self.row = row
        self.col = col
        self.adjacentMines = 0
        
        let texture = SKTexture(imageNamed: "MSTileImage")
        super.init(texture: texture, color: UIColor.white, size: texture.size())
    }
    
    /// This is a required code/decoder used for objects that will appear in the storyboard due to stoyboard's UI (it needs to serialize and deserialize it)
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented yet") // we don't use stinky storyboard here so no need to implement
   }
}

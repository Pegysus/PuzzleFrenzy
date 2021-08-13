//
//  Minesweeper.swift
//  PuzzleFrenzy
//
//  Created by Max Yeh on 8/9/21.
//

import SpriteKit
import GameplayKit

class MinesweeperScene: SKScene {
    
    /* Properties */

    // Constants
    let NUM_ROWS: Int = 13
    let NUM_COLS: Int = 15
    let NUM_MINES: Int = 40
    
    // Nodes
    var msBoard: SKSpriteNode!
    var msGrid: [[MSTile]] = []
    // TODO: use SQLite3 to store board state for scene switch
    
    // Camera Nodes
    var msCameraNode = SKCameraNode()
    
    // Header Nodes
    var msHelpButton: SKSpriteNode!
    var msPauseButton: SKSpriteNode!
    // Timer variables
    var msStartTime: TimeInterval!
    var msTimeLeft: Double!
    // TODO: use SQLite3 to store current time left as the scene switches
    
    // Footer Nodes
    var msDescription: SKLabelNode!
    
    /* Methods */
    
    /* State Changes */
    
    
}

/* Configurations */

extension MinesweeperScene {
    
    func setupNodes() {
        setupBackground()
        setupGrid()
        setupCamera()
        setupHeader()
        setupFooter()
    }
    
    func setupBackground() {
        let background = SKSpriteNode()
        background.name = "background"
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.anchorPoint = .zero
        background.zPosition = -20
        background.color = UIColor.white // TODO: change color
        addChild(background)
    }
    
    func setupGrid() {
        
        // TODO: setup board dimensions, color, etc.
        
        for i in 0...NUM_ROWS {
            for j in 0...NUM_COLS {
                msGrid[i][j] = MSTile(row: i, col: j)
            }
        }
        
        // TODO: set position of tiles given board dimensions
        
        
    }
    
    // Camera setup, set original position to center of the boadd
    func setupCamera() {
        addChild(msCameraNode)
        camera = msCameraNode
        msCameraNode.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
    }
    
    func setupHeader() {
        // TODO: setup pause, "?" button on top
        // TODO: setup timer
    }
    
    func setupFooter() {
        // TODO: create text for description to fill in negative space
    }
    
}

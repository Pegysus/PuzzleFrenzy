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
    var msGrid = [[MSTile]](repeating: [MSTile](repeating: MSTile(), count: 15), count: 13)
    // TODO: use SQLite3 to store board state for scene switch
    
    // Camera Nodes
    var msCameraNode = SKCameraNode()
    
    // Header Nodes
    var msHelpButton: SKSpriteNode!
    var msPauseButton: SKSpriteNode!
    // Timer variables
    var ms15SecondTimerStart: TimeInterval!
    var ms15TimeLeft: Double!
    var ms15Timer: SKSpriteNode!
    
    var msStartTime: TimeInterval!
    var msTimeLeft: Double!
    var msBigTimer: SKSpriteNode!
    // TODO: use SQLite3 to store current time left as the scene switches
    
    // Footer Nodes
    var msInstructions: SKLabelNode!
    var msFlagsLeft: SKSpriteNode!
    var msTilesLeft: SKSpriteNode!
    
    
    /* Methods */
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    /* State Changes */
    
    
}

/* Configurations */

extension MinesweeperScene {
    
    func setupNodes() {
        setupBackground()
        setupGrid()
        setupCamera()
        setupHeader()
        setupTimer()
        setupFooter()
    }
    
    func setupBackground() {
        let background = SKSpriteNode()
        background.name = "background"
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.anchorPoint = .zero
        background.position = .zero
        background.zPosition = -20.0
        background.color = UIColor.white
        addChild(background)
    }
    
    func setupGrid() {
        
        // TODO: setup board dimensions, color, etc.
        msBoard = SKSpriteNode(imageNamed: "MSBoard")
        msBoard.name = "board"
        msBoard.size = CGSize(width: (3.0 / 4.0)*self.frame.width, height: (1.0 / 2.0)*self.frame.height)
        msBoard.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
        msBoard.zPosition = -10.0
        addChild(msBoard)
        
        for i in 0..<NUM_ROWS {
            for j in 0..<NUM_COLS {
                msGrid[i][j] = MSTile(row: i, col: j)
            }
        }
        
        // TODO: set position of tiles given board dimensions
        
        
    }
    
    // Camera setup, set original position to center of the board
    func setupCamera() {
        addChild(msCameraNode)
        camera = msCameraNode
        msCameraNode.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
    }
    
    func setupHeader() {
        msHelpButton = SKSpriteNode(imageNamed: "GHelpButton")
        msHelpButton.name = "help button"
        msHelpButton.size = CGSize(width: (1.0 / 10.0)*self.frame.width, height: (1.0 / 10.0)*self.frame.width)
        msHelpButton.position = CGPoint(x: -(5.0 / 13.0)*self.frame.width, y: (5.0 / 12.0)*self.frame.height)
        msHelpButton.zPosition = 0.0
        camera?.addChild(msHelpButton)
        
        msPauseButton = SKSpriteNode(imageNamed: "GPauseButton")
        msPauseButton.name = "pause button"
        msPauseButton.size = CGSize(width: (1.0 / 10.0)*self.frame.width, height: (1.0 / 10.0)*self.frame.width)
        msPauseButton.position = CGPoint(x: (5.0 / 13.0)*self.frame.width, y: (5.0 / 12.0)*self.frame.height)
        msPauseButton.zPosition = 0.0
        camera?.addChild(msPauseButton)
        
        ms15Timer = SKSpriteNode(imageNamed: "GTimer")
        ms15Timer.name = "15 second timer"
        ms15Timer.size = CGSize(width: (2.0 / 5.0)*self.frame.width, height: (1.0 / 10.0)*self.frame.width)
        ms15Timer.position = CGPoint(x: 0.0, y: (5.0 / 12.0)*self.frame.height)
        ms15Timer.zPosition = 0.0
        camera?.addChild(ms15Timer)
    }
    
    func setupTimer() {
        msBigTimer = SKSpriteNode(imageNamed: "MSHeaderTimer")
        msBigTimer.name = "game timer"
        msBigTimer.size = CGSize(width: (3.0 / 4.0)*self.frame.width, height: (1.0 / 6.0)*self.frame.width)
        msBigTimer.position = CGPoint(x: 0.0, y: (3.66 / 12.0)*self.frame.height)
        msBigTimer.zPosition = 0.0
        camera?.addChild(msBigTimer)
    }
    
    func setupFooter() {
        // TODO: create text for description to fill in negative space
        msFlagsLeft = SKSpriteNode(imageNamed: "MSFooterFlagsLeft")
        msFlagsLeft.name = "flags left"
        msFlagsLeft.size = CGSize(width: (2.5 / 10.0)*self.frame.width, height: (1.3 / 10.0)*self.frame.width)
        msFlagsLeft.position = CGPoint(x: -(1.0 / 5.0)*self.frame.width, y: -(3.66 / 12.0)*self.frame.height)
        msFlagsLeft.zPosition = 0.0
        camera?.addChild(msFlagsLeft)
        
        msTilesLeft = SKSpriteNode(imageNamed: "MSFooterTilesLeft")
        msTilesLeft.name = "flags left"
        msTilesLeft.size = CGSize(width: (2.5 / 10.0)*self.frame.width, height: (1.3 / 10.0)*self.frame.width)
        msTilesLeft.position = CGPoint(x: (1.0 / 5.0)*self.frame.width, y: -(3.66 / 12.0)*self.frame.height)
        msTilesLeft.zPosition = 0.0
        camera?.addChild(msTilesLeft)
    }
    
}

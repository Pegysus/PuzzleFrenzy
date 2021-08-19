//
//  Minesweeper.swift
//  PuzzleFrenzy
//
//  Created by Max Yeh on 8/9/21.
//

import SpriteKit
import GameplayKit

class MinesweeperScene: SKScene {
    
    /// The code is split into 3 groups, properties, methods, and configurations
    /// Properties contain all the variables, both nodes and any game state variables
    /// Methods will contain both gesture recognizers and state changes for those state variables
    /// Configuration handles the visuals of the game, creating and altering the nodes given any updates
    
    /* Properties */

    // Constants
    let NUM_ROWS: Int = 10
    let NUM_COLS: Int = 15
    let NUM_MINES: Int = 30
    
    // Nodes
    var msBoard: SKSpriteNode!
    var msGrid = [[MSTile]](repeating: [MSTile](repeating: MSTile(), count: 15), count: 10) // 13 rows, 15 columns
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
    
    // Temp Nodes
    var touched: SKNode!
    
    // States
    var firstPress = true // check if the user pressed the first time to reveal a tile and start the game
    var isInPause = false // make sure to pause everything when the game is paused
    var isInHelp = false // similar to pause, might delete if redundant
    var gameOver = false // when timer runs out/mine is pressed
    
    
    /* Methods */
    
    // basically the init function, when scene comes into play
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        
        touched = node
    }
    // TODO: going to have to change touchesBegan + touchesEnded and use UIGesture thingies
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        
        if(touched.name == node.name) {
            
            if(touched.name!.contains("tile")) {
                let i = touched.name!.index(touched.name!.startIndex, offsetBy: 4)
                let j = touched.name!.index(touched.name!.startIndex, offsetBy: 5)
                
                let tileRow = Int(String(touched.name![i]))
                let tileCol = Int(String(touched.name![j]))
                
                changeFlagState(row: tileRow!, col: tileCol!)
            }
            
        }
        
    }
    
    // Used to check all the adjacent tiles for mines
    func checkAdjTiles(row: Int, col: Int) -> Int {
        var numAdj = 0
        
        // When i = 0, j = 0 we go on the current tile which technically isn't adjacent
        // Fortunately, we check if the tile is a mine before running this loop,
        // so checking this value doesn't change the value of adjacent mines at all
        for i in -1...1 {
            for j in -1...1 {
                // we use [safe: index] here, refer to Utils/CollectionExt
                if let curTile = msGrid[safe: row+i]![safe: col+j] {
                    if curTile.isMine {
                        numAdj += 1
                    }
                }
            }
        }
        
        return numAdj
    }
    
    func createNumForAdjMines() {
        
        for i in 0..<NUM_ROWS {
            for j in 0..<NUM_COLS {
                if !msGrid[i][j].isMine { // check statement to prevent putting numbers on mines
                    let numAdj = checkAdjTiles(row: i, col: j)
                    msGrid[i][j].adjacentMines = numAdj
                    createNum(row: i, col: j)
                }
            }
        }
        
    }
    
    /* State Changes */
    
    // changes the state of the flag on a certain tile
    func changeFlagState(row: Int, col: Int) {
        if(msGrid[row][col].isFlagged) {
            removeFlag(row: row, col: col)
            msGrid[row][col].isFlagged = false
        } else {
            addFlag(row: row, col: col)
            msGrid[row][col].isFlagged = true
        }
    }
    
}

/* Configurations */

extension MinesweeperScene {
    
    /* Scene changes */
    func removeFlag(row: Int, col: Int) {
        
    }
    func addFlag(row: Int, col: Int) {
        
    }
    func addMine(row: Int, col: Int) {
        
    }
    func createNum(row: Int, col: Int) {
        
    }
    
    /* Scene setup */
    
    // creates all the nodes and stuff
    func setupNodes() {
        setupCamera()
        setupBackground()
        setupGrid()
        setupHeader()
        setupTimer()
        setupFooter()
    }
    
    /// white background + the header and footer when the camera moves
    func setupBackground() {
        let background = SKSpriteNode()
        background.name = "background"
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.anchorPoint = .zero
        background.position = .zero
        background.zPosition = -20.0
        background.color = UIColor.white
        addChild(background)
        
        let headerBackground = SKSpriteNode()
        headerBackground.name = "header background"
        headerBackground.size = CGSize(width: self.frame.width, height: (1.0 / 4.0)*self.frame.height)
        headerBackground.position = CGPoint(x: 0.0, y: -(3.0/8.0)*self.frame.height)
        headerBackground.zPosition = -15.0
        headerBackground.color = UIColor.white
        camera?.addChild(headerBackground)
        
        let footerBackground = SKSpriteNode()
        footerBackground.name = "footer background"
        footerBackground.size = CGSize(width: self.frame.width, height: (1.0 / 4.0)*self.frame.height)
        footerBackground.position = CGPoint(x: 0.0, y: (3.0/8.0)*self.frame.height)
        footerBackground.zPosition = -15.0
        footerBackground.color = UIColor.white
        camera?.addChild(footerBackground)
    }
    
    /// this is both the board and all of the tiles (not revealed at the beginning)
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
                msGrid[i][j].name = "tile" + "\(i)" + "\(j)"
                msGrid[i][j].anchorPoint = CGPoint(x: 0.0, y: 1.0)
                msGrid[i][j].size = CGSize(width: (1.0 / 15.0)*msBoard.size.width, height: (1.0 / 15.0)*msBoard.size.width)
                
                let initialXPos = (1.0/8.0) * self.frame.width + (1/90.0) * self.frame.width
                let xIncrement = (1.0/10.0) * msBoard.size.width * CGFloat(i)
                let initialYPos = (3.0/4.0) * self.frame.height - (1/175.0) * self.frame.height
                let yIncrement = (1.0/15.0) * msBoard.size.height * CGFloat(j)
                msGrid[i][j].position = CGPoint(x: initialXPos + xIncrement, y: initialYPos - yIncrement)
                
                msGrid[i][j].zPosition = 10.0
                addChild(msGrid[i][j])
            }
        }
        // TODO: naming convention of the tiles
        
        // TODO: set position of tiles given board dimensions
        
        
    }
    
    /// Camera setup, set original position to center of the board
    func setupCamera() {
        addChild(msCameraNode)
        camera = msCameraNode
        msCameraNode.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
    }
    
    /// Help, Pause, and 15 second timer all over here
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
    
    /// Flags and Tiles left on the board
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

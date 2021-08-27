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
    let DIRECTIONS: [(Int, Int)] = [(0, 1), (1, 0), (0, -1), (-1, 0), (1, 1), (1, -1), (-1, -1), (-1, 1)] // directions to reveal mines
    let MS_FLAG_TEXTURE = SKTexture(imageNamed: "MSFlagImage") // create texture to duplicate flags
    let MS_MINE_TEXTURE = SKTexture(imageNamed: "MSMineImage") // create texture to duplicate mines
    // textures for the numbers
    let MS_NUMBER_ONE_TEXTURE = SKTexture(imageNamed: "MSNumber1")
    let MS_NUMBER_TWO_TEXTURE = SKTexture(imageNamed: "MSNumber2")
    let MS_NUMBER_THREE_TEXTURE = SKTexture(imageNamed: "MSNumber3")
    let MS_NUMBER_FOUR_TEXTURE = SKTexture(imageNamed: "MSNumber4")
    let MS_NUMBER_FIVE_TEXTURE = SKTexture(imageNamed: "MSNumber5")
    let MS_NUMBER_SIX_TEXTURE = SKTexture(imageNamed: "MSNumber6")
    let MS_NUMBER_SEVEN_TEXTURE = SKTexture(imageNamed: "MSNumber7")
    let MS_NUMBER_EIGHT_TEXTURE = SKTexture(imageNamed: "MSNumber8")
    
    // Nodes
    var msBoard: SKSpriteNode! // background board
    var msGrid = [[MSTile]](repeating: [MSTile](repeating: MSTile(), count: 15), count: 10) // 13 rows, 15 columns
    // 2d grid of empty spritenodes, will be revealed once clicked
    var msFlags = [[SKSpriteNode]](repeating: [SKSpriteNode](repeating: SKSpriteNode(), count: 15), count: 10)
    // list of all the mines, we don't need a grid b/c they don't really do much except vibe there
    var msMines: [SKSpriteNode] = []
    // TODO: use SQLite3 to store board state for scene switch
    
    // Camera Nodes
    var msCameraNode = SKCameraNode()
    
    // Header Nodes
    var msHelpButton: SKSpriteNode!
    var msPauseButton: SKSpriteNode!
    // Timer variables
    var ms15SecondTimerStart: TimeInterval!
    var ms15TimeLeft: Double!
    var msGameTimer: SKSpriteNode!
    
    var msStartTime: TimeInterval!
    var msTimeLeft: Double!
    var msMinigameTimer: SKSpriteNode!
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
        // go to extension to see configuration
        setupNodes()
        
        // single tap gesture, flag/unflag the specific tile
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTapGesture)
        
        // long press gesture, reveal the tile and any nearby ones (if no mine nearby)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        view.addGestureRecognizer(longPressGesture)
    }
    
    // flag and unflag the tile
    @objc func singleTap(_ sender: UITapGestureRecognizer) {
        let touch = sender.location(in: view)
        // convert the touch location relative to the view frame
        let touchPointInScene = view?.scene?.convertPoint(toView: touch)
        
        // find the node being pressed (specifically looking for the tile)
        let node = view?.scene?.atPoint(touchPointInScene!)
        
//        debugging
//        print("single tap, node name: \(node!.name!)")
            
        // if either tile or flag (on top of tile), then find location of node given the name
        if((node!.name!.contains("tile") || node!.name!.contains("flag")) && !gameOver) {
            // find the row and col from the node's name
            let i = node!.name!.index(node!.name!.startIndex, offsetBy: 4)
            let j = node!.name!.index(node!.name!.startIndex, offsetBy: 5)
            
            // convert substring to integer
            let tileRow = Int(String(node!.name![i]))!
            var tileCol = Int(String(node!.name![j]))!
            // 2 digit numbers
            if node!.name!.count > 6 {
                tileCol = Int(String(node!.name!.suffix(2)))!
            }
            
//            debugging
//            print("(\(tileRow), \(tileCol))")
            
            // can only change flag state of tiles that aren't revealed yet
            if(!msGrid[tileRow][tileCol].isRevealed) {
//                debugging
//                print("Changed flag: (\(tileRow), \(tileCol)), position: \(msGrid[tileRow][tileCol].position)")
                
                changeFlagState(row: tileRow, col: tileCol)
            }
        }
    }
    
    @objc func longPress(_ sender: UITapGestureRecognizer) {
        let touch = sender.location(in: view)
        // convert touch location in view
        let touchPointInScene = view?.scene?.convertPoint(toView: touch)
        
        // find the node at the touch location
        let node = view?.scene?.atPoint(touchPointInScene!)
        
//        debugging
//        print("long press, node name: \(node!.name!)")
        
        // if the node is the tile, no need to check flag b/c flagged tiles will not be revealed
        if(node!.name!.contains("tile") && !gameOver) {
            // find the location given the name
            let i = node!.name!.index(node!.name!.startIndex, offsetBy: 4)
            let j = node!.name!.index(node!.name!.startIndex, offsetBy: 5)
            
            // convert substring to int
            let tileRow = Int(String(node!.name![i]))!
            var tileCol = Int(String(node!.name![j]))!
            // convert if 2 digit number exists
            if node!.name!.count > 6 {
                tileCol = Int(String(node!.name!.suffix(2)))!
            }
            
            // checks both revealed and flagged to make sure you don't revealed wrong tile
            if(!msGrid[tileRow][tileCol].isRevealed && !msGrid[tileRow][tileCol].isFlagged) {
//                debugging
//                print("Revealed tile: (\(tileRow), \(tileCol)), position: \(msGrid[tileRow][tileCol].position)")
                
                // first press much create mines afterwards (so you don't accidently click on mine first)
                if firstPress {
                    firstPressed(row: tileRow, col: tileCol)
                } else if msGrid[tileRow][tileCol].isMine {
                    minesBlown()
                } else {
                    revealTileAndNearby(row: tileRow, col: tileCol)
                }
            }
        }
    }
    
    // randomize mines and create numbers
    func firstPressed(row: Int, col: Int) {
        randomizeMines(row: row, col: col)
        createNumForAdjMines()
        changedfirstPressedState()
        revealTileAndNearby(row: row, col: col)
    }
    
    func randomizeMines(row: Int, col: Int) {
        // all the mines
        for _ in 0..<NUM_MINES {
            // keep changing random position until all conditions satisfied
            var isPlaced = false
            
            while !isPlaced {
                let ranRow = Int.random(in: 0..<NUM_ROWS)
                let ranCol = Int.random(in: 0..<NUM_COLS)
                
                // not starting click and not already a mine
                if !msGrid[ranRow][ranCol].isMine && notInBound(row: row, col: col, rowCheck: ranRow, colCheck: ranCol) {
                    changeMineState(row: ranRow, col: ranCol)
                    addMine(row: ranRow, col: ranCol)
//                    debugging
//                    print("mine placed location (\(ranRow), \(ranCol))")
                    isPlaced = true
                }
            }
        }
    }
    
    func notInBound(row: Int, col: Int, rowCheck: Int, colCheck: Int) -> Bool {
        return (rowCheck < row-1 || rowCheck > row+1) && (colCheck < col-1 || colCheck > col+1)
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
                if let curTile = msGrid[safe: row+i]?[safe: col+j] {
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
                    // try to create number, will return error if some error occurs
                    if msGrid[i][j].adjacentMines != 0 {
                        do {
                            try createNum(row: i, col: j)
                        } catch MinesweeperErrors.AdjacencyNumberOutOfBounds(let errorMessage) {
                            print(errorMessage)
                        } catch {
                            // catch any other possible errors
                        }
                    }
                }
            }
        }
    }
    
    func revealTileAndNearby(row: Int, col: Int) {
        // reveal current tile
        revealTile(row: row, col: col)
        // only reveal if current tile has no number
        // TODO: might need to change the loop to ensure that corners get revealed as well
        if msGrid[row][col].adjacentMines == 0 {
            for i in 0..<8 {
                if let curTile = msGrid[safe: row+DIRECTIONS[i].0]?[safe: col+DIRECTIONS[i].1] {
                    if !curTile.isRevealed {
                        revealTileAndNearby(row: row+DIRECTIONS[i].0, col: col+DIRECTIONS[i].1)
                    }
                }
            }
        }
    }
    
    func minesBlown() {
        changeGameOver()
        revealMines()
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
    
    // should only be caleld once
    func changedfirstPressedState() {
        firstPress = false
    }
    
    // just to change mine state
    func changeMineState(row: Int, col: Int) {
        msGrid[row][col].isMine = true
    }
    
    func changeGameOver() {
        gameOver = true
    }
    
}

/* Configurations */

extension MinesweeperScene {
    
    /* Scene changes */
    func removeFlag(row: Int, col: Int) {
        let removeAction = SKAction.fadeAlpha(to: 0.0, duration: 0.0)
        msFlags[row][col].run(removeAction)
    }
    func addFlag(row: Int, col: Int) {
        let addAction = SKAction.fadeAlpha(to: 1.0, duration: 0.0)
        msFlags[row][col].run(addAction)
    }
    // reveal current tile by changing opacity to 0
    func revealTile(row: Int, col: Int) {
        msGrid[row][col].isRevealed = true
        let removeAction = SKAction.fadeAlpha(to: 0.0, duration: 0.0)
//        debugging
//        print("reiterate coord of grid: (\(row), \(col))")
        msGrid[row][col].run(removeAction)
    }
    func addMine(row: Int, col: Int) {
        let newMine = SKSpriteNode(texture: MS_MINE_TEXTURE)
        newMine.name = "msMine"
        newMine.size = CGSize(width: msGrid[row][col].size.width * 0.8,
                              height: msGrid[row][col].size.height * 0.8)
        newMine.position = CGPoint(x: msGrid[row][col].position.x + msGrid[row][col].size.width * 0.5,
                                   y: msGrid[row][col].position.y + msGrid[row][col].size.height * 0.5)
        newMine.zPosition = 20.0
        newMine.alpha = 0.0
        msMines.append(newMine)
        addChild(newMine)
    }
    func revealMines() {
        for i in 0..<msMines.count {
            let waitAction = SKAction.wait(forDuration: 0.1 * Double(i))
            let addAction = SKAction.fadeAlpha(to: 1.0, duration: 0.1)
            msMines[i].run(SKAction.sequence([waitAction, addAction]))
        }
    }
    func createNum(row: Int, col: Int) throws {
        var newNumber = SKSpriteNode()
        switch msGrid[row][col].adjacentMines {
        case 1:
            newNumber = SKSpriteNode(texture: MS_NUMBER_ONE_TEXTURE)
            break
        case 2:
            newNumber = SKSpriteNode(texture: MS_NUMBER_TWO_TEXTURE)
            break
        case 3:
            newNumber = SKSpriteNode(texture: MS_NUMBER_THREE_TEXTURE)
            break
        case 4:
            newNumber = SKSpriteNode(texture: MS_NUMBER_FOUR_TEXTURE)
            break
        case 5:
            newNumber = SKSpriteNode(texture: MS_NUMBER_FIVE_TEXTURE)
            break
        case 6:
            newNumber = SKSpriteNode(texture: MS_NUMBER_SIX_TEXTURE)
            break
        case 7:
            newNumber = SKSpriteNode(texture: MS_NUMBER_SEVEN_TEXTURE)
            break
        case 8:
            newNumber = SKSpriteNode(texture: MS_NUMBER_EIGHT_TEXTURE)
            break
        default:
            throw MinesweeperErrors.AdjacencyNumberOutOfBounds("trying to create number that doesn't exist location (\(row), \(col))")
        }
        newNumber.name = "msNumber"
        newNumber.setScale(0.18)
        newNumber.position = CGPoint(x: msGrid[row][col].position.x + msGrid[row][col].size.width * 0.5,
                                     y: msGrid[row][col].position.y + msGrid[row][col].size.height * 0.5)
        newNumber.zPosition = 5.0
        addChild(newNumber)
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
        // background, full frame color white
        let background = SKSpriteNode()
        background.name = "background"
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.anchorPoint = .zero
        background.position = .zero
        background.zPosition = -20.0
        background.color = UIColor.white
        addChild(background)
        
        // use a headerBackground for the camera so that it won't be affected by the zoom
        let headerBackground = SKSpriteNode()
        headerBackground.name = "header background"
        headerBackground.size = CGSize(width: self.frame.width, height: (1.0 / 4.0)*self.frame.height)
        headerBackground.position = CGPoint(x: 0.0, y: -(3.0/8.0)*self.frame.height)
        headerBackground.zPosition = -15.0
        headerBackground.color = UIColor.white
        camera?.addChild(headerBackground)
        
        // use a footerBackground for the camera so that it won't be affected by the zoom
        let footerBackground = SKSpriteNode()
        footerBackground.name = "footer background"
        footerBackground.size = CGSize(width: self.frame.width, height: (1.0 / 4.0)*self.frame.height)
        footerBackground.position = CGPoint(x: 0.0, y: (3.0/8.0)*self.frame.height)
        footerBackground.zPosition = -15.0
        footerBackground.color = UIColor.white
        camera?.addChild(footerBackground)
    }
    
    /// this is both the board and all of the tiles and flags (not revealed at the beginning)
    func setupGrid() {
        // create board, beige, 1/2 of the frame
        msBoard = SKSpriteNode(imageNamed: "MSBoard")
        msBoard.name = "board"
        msBoard.size = CGSize(width: (3.0 / 4.0)*self.frame.width, height: (1.0 / 2.0)*self.frame.height)
        msBoard.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
        msBoard.zPosition = -10.0
        addChild(msBoard)
        
        // create each tile and flag
        for i in 0..<NUM_ROWS {
            for j in 0..<NUM_COLS {
                msGrid[i][j] = MSTile(row: i, col: j)
                msGrid[i][j].name = "tile" + "\(i)" + "\(j)"
                
                msGrid[i][j].anchorPoint = .zero
                msGrid[i][j].size = CGSize(width: (1.0 / 15.0)*msBoard.size.width, height: (1.0 / 15.0)*msBoard.size.width)
                
                // weird position calculations, but works ig
                let initialXPos = (1.0/8.0) * self.frame.width + (1/90.0) * self.frame.width
                let xIncrement = (1.0/10.0) * msBoard.size.width * CGFloat(i)
                let initialYPos = (1.0/4.0) * self.frame.height + (1/175.0) * self.frame.height
                let yIncrement = (1.0/15.0) * msBoard.size.height * CGFloat(j)
                msGrid[i][j].position = CGPoint(x: initialXPos + xIncrement, y: initialYPos + yIncrement)
                
                msGrid[i][j].zPosition = 10.0
                
                addChild(msGrid[i][j])
                
                // use tile position to make this much easier
                msFlags[i][j] = SKSpriteNode(texture: MS_FLAG_TEXTURE)
                msFlags[i][j].name = "flag" + "\(i)" + "\(j)"
                msFlags[i][j].anchorPoint = .zero
                msFlags[i][j].size = CGSize(width: msGrid[i][j].size.width * 0.8,
                                            height: msGrid[i][j].size.height * 0.8)
                msFlags[i][j].position = CGPoint(x: msGrid[i][j].position.x + msGrid[i][j].size.width * 0.05,
                                                 y: msGrid[i][j].position.y + msGrid[i][j].size.height * 0.1)
                msFlags[i][j].zPosition = 15.0
                msFlags[i][j].alpha = 0.0
                addChild(msFlags[i][j])
            }
        }
    }
    
    /// Camera setup, set original position to center of the board
    func setupCamera() {
        // just create camera for zoom options
        addChild(msCameraNode)
        camera = msCameraNode
        msCameraNode.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
    }
    
    /// Help, Pause, and 15 second timer all over here
    func setupHeader() {
        // help button, should be the same for all the scenes
        msHelpButton = SKSpriteNode(imageNamed: "GHelpButton")
        msHelpButton.name = "help button"
        msHelpButton.size = CGSize(width: (1.0 / 10.0)*self.frame.width, height: (1.0 / 10.0)*self.frame.width)
        msHelpButton.position = CGPoint(x: -(5.0 / 13.0)*self.frame.width, y: (5.0 / 12.0)*self.frame.height)
        msHelpButton.zPosition = 0.0
        camera?.addChild(msHelpButton)
        
        // pause button, should be the same for all the scenes
        msPauseButton = SKSpriteNode(imageNamed: "GPauseButton")
        msPauseButton.name = "pause button"
        msPauseButton.size = CGSize(width: (1.0 / 10.0)*self.frame.width, height: (1.0 / 10.0)*self.frame.width)
        msPauseButton.position = CGPoint(x: (5.0 / 13.0)*self.frame.width, y: (5.0 / 12.0)*self.frame.height)
        msPauseButton.zPosition = 0.0
        camera?.addChild(msPauseButton)
        
        // game timer, should be the same for all the scenes
        msGameTimer = SKSpriteNode(imageNamed: "GTimer")
        msGameTimer.name = "game timer"
        msGameTimer.size = CGSize(width: (2.0 / 5.0)*self.frame.width, height: (1.0 / 10.0)*self.frame.width)
        msGameTimer.position = CGPoint(x: 0.0, y: (5.0 / 12.0)*self.frame.height)
        msGameTimer.zPosition = 0.0
        camera?.addChild(msGameTimer)
    }
    
    func setupTimer() {
        // in game timer, bigger than the 15 second timer
        msMinigameTimer = SKSpriteNode(imageNamed: "MSHeaderTimer")
        msMinigameTimer.name = "minigame timer"
        msMinigameTimer.size = CGSize(width: (3.0 / 4.0)*self.frame.width, height: (1.0 / 6.0)*self.frame.width)
        msMinigameTimer.position = CGPoint(x: 0.0, y: (3.66 / 12.0)*self.frame.height)
        msMinigameTimer.zPosition = 0.0
        camera?.addChild(msMinigameTimer)
    }
    
    /// Flags and Tiles left on the board
    func setupFooter() {
        // TODO: create text for description to fill in negative space
        // the number of flags left
        msFlagsLeft = SKSpriteNode(imageNamed: "MSFooterFlagsLeft")
        msFlagsLeft.name = "flags left"
        msFlagsLeft.size = CGSize(width: (2.5 / 10.0)*self.frame.width, height: (1.3 / 10.0)*self.frame.width)
        msFlagsLeft.position = CGPoint(x: -(1.0 / 5.0)*self.frame.width, y: -(3.66 / 12.0)*self.frame.height)
        msFlagsLeft.zPosition = 0.0
        camera?.addChild(msFlagsLeft)
        
        // the number of total tiles left (kind of useless but wtv)
        msTilesLeft = SKSpriteNode(imageNamed: "MSFooterTilesLeft")
        msTilesLeft.name = "flags left"
        msTilesLeft.size = CGSize(width: (2.5 / 10.0)*self.frame.width, height: (1.3 / 10.0)*self.frame.width)
        msTilesLeft.position = CGPoint(x: (1.0 / 5.0)*self.frame.width, y: -(3.66 / 12.0)*self.frame.height)
        msTilesLeft.zPosition = 0.0
        camera?.addChild(msTilesLeft)
    }
    
}

// some errors to prevent actual out of bounds/other problems
enum MinesweeperErrors: Error {
    case AdjacencyNumberOutOfBounds(String)
}

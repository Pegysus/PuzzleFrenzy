//
//  WordSearchScene.swift
//  PuzzleFrenzy
//
//  Created by Max Yeh on 8/9/21.
//

import SpriteKit
import GameplayKit

class WordSearchScene: SKScene {
        
    
    /* Properties */
    var wsCameraNode = SKCameraNode()
    let wordBank = ["candy","cotton","apple","hungry","tired","sleepy","berry","dora","minority","cake","turnip","cake"]
    
    let NUM_ROWS: Int = 8
    let NUM_COLS: Int = 8
    
    var wsBoard: SKSpriteNode!
    var wsLetterGrid = [[SKLabelNode]](repeating: [SKLabelNode](repeating: SKLabelNode(), count: 8), count: 8)
    var wsLetters = [[Character]](repeating: [Character](repeating: ".", count: 8), count: 8)
    
    var wsHelpButton: SKSpriteNode!
    var wsPauseButton: SKSpriteNode!
    
    var wsGameTimer: SKSpriteNode!
    var wsMinigameTimer: SKSpriteNode!
    
    let directions : [(Int, Int)] = [(0,1), (-1, 0),(1,1),(-1,-1),(1,0),(-1,0)]
    
    /* Methods */
    
    // didMove = init function
    override func didMove(to view: SKView) {
        setupNodes()
    }

    func placeWord(word: String) {
        var i = Int.random(in: 0..<8)
        var j = Int.random(in: 0..<8)
        var wordCanBePlaced = false
        var wordIsPlaced = false
        let wordLen = word.count
        var currentDirection = 0
        
        // runs while the word is still being placed
        while !wordIsPlaced {
            var char = 0
            // if at end of direction array, new i & j
            if currentDirection >= directions.count {
                i = Int.random(in: 0..<8)
                j = Int.random(in: 0..<8)
                currentDirection = 0
            }
            if ( i + directions[currentDirection].0 >= 8 || j + directions[currentDirection].1 >= 8 ) || ( i + directions[currentDirection].0 < 0 || j + directions[currentDirection].1 < 0 ){
                currentDirection += 1
            }
            var z = 0
            var inew = i
            var jnew = j
            // runs for the length of wordLen
            for _ in 0..<wordLen {
                if (jnew >= 8 || inew >= 8 ) || (jnew < 0 || inew < 0) {
                    wordCanBePlaced = false
                    currentDirection += 1
                    break
                }
                else if z == wordLen {
                    wordCanBePlaced = true
                    break
                }
                else if currentDirection >= directions.count {
                    i = Int.random(in: 0..<8)
                    j = Int.random(in: 0..<8)
                    currentDirection = 0
                    break
                }
                else if z < wordLen && (wsLetters[inew][jnew] == "." || wsLetters[inew][jnew] == word[word.index(word.startIndex, offsetBy: z)]) {
                    inew += directions[currentDirection].0
                    jnew += directions[currentDirection].1
                    wordCanBePlaced = true
                    z += 1
                }
                else {
                    wordCanBePlaced = false
                    currentDirection += 1
                    break
                }
            }
            // if the word can be placed, then the function will then start to place the words in the 2d array
            if wordCanBePlaced {
                char = 0
                inew = i
                jnew = j
                for _ in 0..<wordLen {
                    if wsLetters[inew][jnew] == "." || wsLetters[inew][jnew] == word[word.index(word.startIndex, offsetBy: char)] {
                        wsLetters[inew][jnew] = word[word.index(word.startIndex, offsetBy: char)]
                        char += 1
                        print (wsLetters)
                        inew += directions[currentDirection].0
                        jnew += directions[currentDirection].1
                        }
                    wordIsPlaced = true
                }
            }
        }
    }
    // finds random words and fills the 2d array with 6 of them
    func findWordsAndFill() {
        var randIndex : Int
        var previousIndex: [Int] = [-1]
        for _ in 0...6 {
            // makes sure no words are repeated
            randIndex = Int.random(in: 0..<directions.count)
            // adds words to 2d array
            if !previousIndex.contains(randIndex) {
                placeWord( word: wordBank[randIndex] )
                // makes sure no words are repeated
                previousIndex.append(randIndex)
            }
        }
    }
    
    // this func fills up the board
    // (!) rn words r hardcoded in, need a function to randomly fill words + wordbank
    func prepareBoard()  {
        findWordsAndFill()
        print(wsLetters)
    }
    
} // word search scene


/* Configuration */

extension WordSearchScene {
    
    // this displays stuff
    func setupNodes() {
        setupBackground()
        setupHeader()
        setupGrid()
    }
    
    // stolen from max, i need to modify later maybe :^)
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
    
    func setupGrid(){
        wsBoard = SKSpriteNode(imageNamed: "WSBoard")
        wsBoard.name = "board"
        wsBoard.size = CGSize(width: (3.0 / 4.0)*self.frame.width, height: (1.0 / 2.0)*self.frame.height)
        wsBoard.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
        wsBoard.zPosition = -10.0
        addChild(wsBoard)
        prepareBoard()
        print (wsLetters)
        
    }
    
    func setupCamera() {
        addChild(wsCameraNode)
        camera = wsCameraNode
        wsCameraNode.position = CGPoint(x: self.frame.width/2.0, y: self.frame.height/2.0)
    }
    
    // sets up the timers and help/pause buttons
    func setupHeader() {
        
    }
    
}

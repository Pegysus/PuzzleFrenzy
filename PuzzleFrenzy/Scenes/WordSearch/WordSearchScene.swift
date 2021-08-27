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

    let wordBank = ["candy","cotton","apple","hungry","tired","sleepy","berry","dora","minority","cake","turnip"]
    
    let NUM_ROWS: Int = 8
    let NUM_COLS: Int = 8
    
    var wsBoard: SKSpriteNode!
    var wsLetterGrid = [[SKLabelNode]](repeating: [SKLabelNode](repeating: SKLabelNode(), count: 8), count: 8)
    var wsLetters = [[Character]](repeating: [Character](repeating: ".", count: 8), count: 8)
    
    var wsHelpButton: SKSpriteNode!
    var wsPauseButton: SKSpriteNode!
    
    var wsGameTimer: SKSpriteNode!
    var wsMinigameTimer: SKSpriteNode!
    
    
    /* Methods */
    
    // didMove = init function
    override func didMove(to view: SKView) {
        setupNodes()
    }

    // checks and places words left to right
    func placeWordLR(word: String) {
        var wordIsPlaced = false
        var j : Int
        var i : Int
        var inBounds = false
        let wordLen = word.count
        var wordCannotBePlaced = true
        
        while !wordIsPlaced {
            // randomly pics a place for the row/col for the word
            j = Int.random(in: 0..<8)
            i = Int.random(in: 0..<8)
            // checks if j are within the bounds of the array still if we were to place the word
            // if the word length can fit in that row, will make inBounds = true
            if ( 8 - j ) >= wordLen {
                inBounds = true
            }
            // check each letter to see if it works
            if inBounds {
              // runs from j
                var z = 0
                for k in j ... 7 {
                    if wsLetters[i][k] == "." || wsLetters[i][k] == word[word.index(word.startIndex, offsetBy: z)] {
                        wordCannotBePlaced = false
                        z += 1
                    }
                    else {
                        wordCannotBePlaced = true
                    }
                }
            }
            if wordCannotBePlaced {
                wordIsPlaced = false
            }
            else {
                // places word into array
                var lc = 0
                for n in j ... (j + wordLen - 1) {
                    wsLetters[i][n] = word[word.index(word.startIndex, offsetBy: lc)]
                    //print (wsLetters)
                    lc += 1
                }
                wordIsPlaced = true
            }
        } // while end
    }// func ends here

    // checks and places a word top to bottom
    func placeWordTB(word: String) {
        var wordIsPlaced = false
        var j : Int
        var i : Int
        var inBounds = false
        let wordLen = word.count
        var wordCannotBePlaced = true
        
        while !wordIsPlaced {
            // randomly pics a place for the row/col for the word
            j = Int.random(in: 0..<8)
            i = Int.random(in: 0..<8)
            // checks if i within the bounds of the array still if we were to place the word
            // if the word length can fit in that row, will make inBounds = true
            if ( 8 - i ) >= wordLen {
                inBounds = true
            }
            // check each letter to see if it works
            if inBounds {
              // runs from j
                var z = 0
                for k in i ... 7 {
                    if wsLetters[k][j] == "." || wsLetters[k][j] == word[word.index(word.startIndex, offsetBy: z)] {
                        wordCannotBePlaced = false
                        z += 1
                    }
                    else {
                        wordCannotBePlaced = true
                    }
                }
            }
            if wordCannotBePlaced {
                wordIsPlaced = false
            }
            else {
                // places word into array
                var lc = 0
                for n in i ... (i + wordLen - 1) {
                    wsLetters[n][j] = word[word.index(word.startIndex, offsetBy: lc)]
                    //print (wsLetters)
                    lc += 1
                }
                wordIsPlaced = true
            }
        } // while end
    }// func ends here
    
   
    /*
    //(!) issues with this one
    // diagonal left to right
    func placeWordDLR(word: String) {
        var wordIsPlaced = false
        var j : Int
        var i : Int
        var inBounds = false
        let wordLen = word.count
        var wordCannotBePlaced = true
        
        while !wordIsPlaced {
            // randomly pics a place for the row/col for the word
            j = Int.random(in: 0..<8)
            i = Int.random(in: 0..<8)
            // checks if i within the bounds of the array still if we were to place the word
            // if the word length can fit in that row, will make inBounds = true
            if ( 8 - i ) >= wordLen && ( 8 - j ) >= wordLen{
                inBounds = true
            }
            // check each letter to see if it works
            if inBounds {
              // runs from j
                var z = 0
                var p = j
                for k in i ... 7 {
                    // (!) the || if letter char = board char part no work
                    if wsLetters[k][p] == "." || wsLetters[k][p] == word[word.index(word.startIndex, offsetBy: z)] {
                        print(word[word.index(word.startIndex, offsetBy: z)])
                        wordCannotBePlaced = false
                        print(wsLetters)
                        z += 1
                        p += 1
                    }
                    else {
                        wordCannotBePlaced = true
                    }
                }
            }
            if wordCannotBePlaced {
                wordIsPlaced = false
            }
            else {
                // places word into array
                var lc = 0
                var yplace = j
                for n in i ... (i + wordLen - 1) {
                    wsLetters[n][yplace] = word[word.index(word.startIndex, offsetBy: lc)]
                   //print (wsLetters)
                    lc += 1
                    yplace += 1
                }
                wordIsPlaced = true
            }
        } // while end
    }// func ends here
    */
    
    
    // this func fills up the board
    // (!) rn words r hardcoded in, need a function to randomly fill words + wordbank
    func prepareBoard()  {

        placeWordLR(word: "candy")
        print (wsLetters)

        placeWordTB(word: "turnip")
        print (wsLetters)
        
        placeWordDLR(word: "cake")
        print (wsLetters)

        
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

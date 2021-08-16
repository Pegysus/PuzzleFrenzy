//
//  GameViewController.swift
//  PuzzleFrenzy
//
//  Created by Max Yeh on 8/4/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = view as! SKView
        
        let scene = MinesweeperScene(size: view.bounds.size)
        scene.scaleMode = .aspectFit
        scene.size = view.bounds.size
        print(view.bounds.size)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }

}

//
//  GameViewController.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
//import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let sceneNode = GameScene(size: view.frame.size) as! GameScene? {

            sceneNode.scaleMode = .aspectFill

            if let view = self.view as! SKView? {

                view.showsFPS = true
                view.showsNodeCount = true
                view.showsPhysics = true


                view.presentScene(sceneNode)
            }

        }
        
        
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//
//  PauseGameViewController.swift
//  Odessa
//
//  Created by Michelle Beadle on 19/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class PauseGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GKScene(fileNamed: "PauseGameScene") {
            
            if let sceneNode = scene.rootNode as! PauseGameScene? {
                
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    
//                    view.ignoresSiblingOrder = true
//                    view.showsFPS = true
//                    view.showsNodeCount = true
                    
                    view.presentScene(sceneNode)
                }
            }
        }

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

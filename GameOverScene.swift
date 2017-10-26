//
//  GameOverScene.swift
//  Odessa
//
//  Created by Mariela Andrade on 26/10/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class GameOverScene: SKScene {
    
    
    let yesButton = SKSpriteNode(imageNamed: "yes") // Sim
    let noButton = SKSpriteNode(imageNamed: "no") // Nao
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        print("GameOver")
        print("E morreu")
        
        self.yesButton.position = CGPoint(x: frame.midX - 20, y: frame.midY - 40) //100
        self.noButton.position = CGPoint(x: frame.midX + 90, y: frame.midY - 40) //100
        yesButton.zPosition = 2
        yesButton.setScale(0.4)
        noButton.setScale(0.4)
        noButton.zPosition = 2
        
        addChild(yesButton)
        addChild(noButton)
        
        let background = SKSpriteNode(imageNamed: "GameOver")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = -1
        
        addChild(background)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self))
            
            let location = t.location(in: self)
            
            if (yesButton.frame.contains(location)){
                
                print("yes")
                
                let newScene = HomePlayerStatusScene(size: self.size)
                let animation = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(newScene, transition: animation)
                
                
            }
                
            else if (noButton.frame.contains(location)){
                
                print("no")
                let newScene = HomeScene(size: self.size)
                let animation = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(newScene, transition: animation)
                
            }
        }
    }
}

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
    
    
    let continueButton = SKSpriteNode(imageNamed: "continue") // Sim
    let homeButton = SKSpriteNode(imageNamed: "smallHomeButton") // Nao
    var pigComendo = [SKTexture]()
    var pig = SKSpriteNode()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        
        view?.backgroundColor = UIColor.black
        
        let title = SKSpriteNode(imageNamed: "odessa")
        title.position = CGPoint(x: frame.midX, y: screenHeight*0.15)
        title.zPosition = 2
        title.setScale(0.4)
        
        addChild(title)
        
        //
        for i in 1...2 {
            pigComendo.append(SKTexture(imageNamed:("porquinho-comendo\(i)")))
        }
        
        pig = SKSpriteNode(texture: pigComendo[0])
        pig.zPosition = 2
        pig.setScale(0.55)
        
        let comendoAction = SKAction.animate(with: pigComendo, timePerFrame: 0.9, resize: true, restore: false)
        
        pig.position = CGPoint(x: screenWidth*0.5, y: screenHeight*0.65)
        
        let repeatAction = SKAction.repeatForever(comendoAction)
        
        pig.run(repeatAction, withKey: "repeatAction")
        addChild(pig)
        //
        
        self.continueButton.position = CGPoint(x: screenWidth*0.3, y: screenHeight*0.4) //100
        self.homeButton.position = CGPoint(x: screenWidth*0.7, y: screenHeight*0.4) //100
        continueButton.zPosition = 2
        continueButton.size = CGSize(width: screenWidth*0.38, height: screenWidth*0.06)
        homeButton.size = CGSize(width: screenWidth*0.38, height: screenWidth*0.06)
        homeButton.zPosition = 2
        
        addChild(continueButton)
        addChild(homeButton)
        
//        let continuesLeft = SKLabelNode(fontNamed: "Montserrat-Regular")
//        continuesLeft.text = "Continues left:"
//        continuesLeft.fontSize = 20
//        continuesLeft.zPosition = 3
//        continuesLeft.horizontalAlignmentMode = .center
//        continuesLeft.position = CGPoint(x: screenWidth*0.46 , y: screenHeight*0.25)
//        addChild(continuesLeft)
//
//        let continuesNumber = SKLabelNode(fontNamed: "Montserrat-Regular")
//        continuesNumber.text = "999"
//        continuesNumber.fontSize = 20
//        continuesNumber.zPosition = 3
//        continuesNumber.horizontalAlignmentMode = .center
//        continuesNumber.position = CGPoint(x: screenWidth*0.61 , y: screenHeight*0.25)
//        addChild(continuesNumber)
        
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
            
            if (continueButton.frame.contains(location)){
                
                
                let nextScene = GameScene(size: frame.size)
                self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 1.0))
                //self.view?.presentScene(newScene, transition: animation)
                
                
            }
                
            else if (homeButton.frame.contains(location)){
                
                let newScene = HomeScene(size: self.size)
                let animation = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(newScene, transition: animation)
                
            }
        }
    }
}

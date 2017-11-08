//
//  NoContinuesGameOver.swift
//  Odessa
//
//  Created by Antonio Salgado on 08/11/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class NoCOntinuesGameOver: SKScene {
    
    
    let getMoreButton = SKSpriteNode(imageNamed: "getMore") // Sim
    let watchVideoButton = SKSpriteNode(imageNamed: "watchVideo") // Nao
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
        
        self.getMoreButton.position = CGPoint(x: screenWidth*0.3, y: screenHeight*0.4) //100
        self.watchVideoButton.position = CGPoint(x: screenWidth*0.7, y: screenHeight*0.4) //100
        getMoreButton.zPosition = 2
        getMoreButton.size = CGSize(width: screenWidth*0.38, height: screenWidth*0.06)
        watchVideoButton.size = CGSize(width: screenWidth*0.38, height: screenWidth*0.06)
        watchVideoButton.zPosition = 2
        
        addChild(getMoreButton)
        addChild(watchVideoButton)
        
        let tapToLeave = SKLabelNode(fontNamed: "Montserrat-Regular")
        tapToLeave.text = "Tap to leave"
        tapToLeave.fontSize = 20
        tapToLeave.zPosition = 3
        tapToLeave.horizontalAlignmentMode = .center
        tapToLeave.position = CGPoint(x: screenWidth*0.46 , y: screenHeight*0.25)
        addChild(tapToLeave)
        
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
        
        let nextScene = HomeScene(size: frame.size)
        self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 1.0))
        
        for t in touches { self.touchDown(atPoint: t.location(in: self))
            
            let location = t.location(in: self)
            
            if (getMoreButton.frame.contains(location)){
                
                
                let nextScene = GameScene(size: frame.size)
                self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 1.0))
                //self.view?.presentScene(newScene, transition: animation)
                
                
            }
                
            else if (watchVideoButton.frame.contains(location)){
                
                let newScene = HomeScene(size: self.size)
                let animation = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(newScene, transition: animation)
                
            }
        }
    }
}

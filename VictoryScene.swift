//
//  VictoryScene.swift
//  Odessa
//
//  Created by Mariela Andrade on 27/10/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class VictoryScene: SKScene {

    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    override func sceneDidLoad() {
        print("GameOver")
        
        
        let winLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
        winLabel.text = "Fim do testflight"     //colocar mensagem de vitoria aqui
        winLabel.fontSize = 30
        winLabel.zPosition = 3
        winLabel.horizontalAlignmentMode = .center
        winLabel.position = CGPoint(x: frame.midX , y: frame.midY )
        addChild(winLabel)
        
   
        let continueLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
        continueLabel.text = "continue"
        continueLabel.fontSize = 15
        continueLabel.zPosition = 3
        continueLabel.horizontalAlignmentMode = .center
        continueLabel.position = CGPoint(x: frame.midX , y: frame.midY - 100 )
        addChild(continueLabel)
        
        let fadeAway = SKAction.fadeOut(withDuration: 0.65)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        
        let sequence = SKAction.sequence([fadeAway, fadeIn])
        let repeatA = SKAction.repeatForever(sequence)
        
        continueLabel.run(repeatA)
        
        
        
        
        let title = SKSpriteNode(imageNamed: "odessa")
        title.setScale(0.5)
        title.position = CGPoint(x: frame.midX, y: frame.midY + 70)
        title.zPosition = 2
        addChild(title)
  
        let background = SKSpriteNode(imageNamed: "IntroBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = -1
        
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let nextScene = HomeScene(size: self.size)
        nextScene.scaleMode = self.scaleMode
        nextScene.backgroundColor = UIColor.black
        self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 1.5))
        
       
    }

}

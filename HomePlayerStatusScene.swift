//
//  HomePlayerStatus.swift
//  Odessa
//
//  Created by Michelle Beadle on 19/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class HomePlayerStatusScene: SKScene {
    
    //Fundo animado
    
    //Public
    let statusPlayerButton = SKSpriteNode(imageNamed: "fundoLevel")
    let cancelButton = SKSpriteNode(imageNamed: "1024px-Crystal_button_cancel")
    let statusPlayerText = SKLabelNode(text: "AAAAAA")

    override func sceneDidLoad() {
        
        //print("Player Status")
        
        // -- Background --
        let background = SKSpriteNode(imageNamed: "IntroBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = -1
        
        addChild(background)
        
        // -- Buttons --
        
        //Status Player -- colocar texto no botão(status player text)
        statusPlayerButton.position = CGPoint(x: frame.midX ,y: frame.midY)
        statusPlayerButton.zPosition = 1
        statusPlayerButton.size = CGSize(width: 400, height: 200) //500 300
        
        addChild(statusPlayerButton)
        
        //Cancel
        cancelButton.position = CGPoint(x: frame.midX + 250 ,y: frame.midY + 110) //300 150
        cancelButton.zPosition = 1
        cancelButton.size = CGSize(width: 50, height: 50)
        
        addChild(cancelButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch touchedNode {
                
            case statusPlayerButton:
                //print("Play game")
                
                let nextScene = GameScene(size: frame.size)
                view?.presentScene(nextScene)
                
            case cancelButton:
                //print("Voltar")
                
                let backScene = HomeOptionsScene(size: frame.size)
                view?.presentScene(backScene)
                
            default:
                print("Not an avaliable button")
            }
            
        }
    }

    
}

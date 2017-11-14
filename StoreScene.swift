//
//  StoreScene.swift
//  Odessa
//
//  Created by João Rafael de Aquino on 13/11/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class StoreScene: SKScene {
    
    let cardCompra1 = SKSpriteNode(imageNamed: "cardCompra1")
    let cardCompra2 = SKSpriteNode(imageNamed: "cardCompra2")
    let cardCompra3 = SKSpriteNode(imageNamed: "cardCompra3")
    let titulo = SKSpriteNode(imageNamed: "titulo")
    let moeda = SKSpriteNode(imageNamed: "moeda2")
    let background = SKSpriteNode(imageNamed: "IntroBackground")
    let botaoGet1 = SKSpriteNode(imageNamed: "botaoGet")
    let botaoGet2 = SKSpriteNode(imageNamed: "botaoGet")
    let botaoGet3 = SKSpriteNode(imageNamed: "botaoGet")
    let botaoVoltar = SKSpriteNode(imageNamed: "voltar")
    
    
    override func sceneDidLoad() {
       
        titulo.position = CGPoint(x: 0.5*screenWidth, y: 0.86*screenHeight)
        titulo.size = CGSize(width: 95/667*screenWidth, height: 20/375*screenHeight)
        
        botaoVoltar.position = CGPoint(x: 0.1*screenWidth, y: 0.86*screenHeight)
        botaoVoltar.size = CGSize(width: 12.5/667*screenWidth, height: 25/375*screenHeight)
        
        
        moeda.position = CGPoint(x: 0.9*screenWidth, y: 0.86*screenHeight)
        moeda.size = CGSize(width: 30/667*screenWidth, height: 37/375*screenHeight)


        
        cardCompra1.position = CGPoint(x:0.26*screenWidth, y:0.44*screenHeight)
        cardCompra1.size = CGSize(width: 140/667*screenWidth, height: 233/375*screenHeight)
        
        cardCompra2.position = CGPoint(x:0.5*screenWidth, y:0.44*screenHeight)
        cardCompra2.size = CGSize(width: 140/667*screenWidth, height: 233/375*screenHeight)
        
        cardCompra3.position = CGPoint(x:0.74*screenWidth, y:0.44*screenHeight)
        cardCompra3.size = CGSize(width: 140/667*screenWidth, height: 233/375*screenHeight)
        
       
        botaoGet1.position = CGPoint(x:0.26*screenWidth, y:0.215*screenHeight)
        botaoGet1.size = CGSize(width: 119/667*screenWidth, height: 32/375*screenHeight)
        
        botaoGet2.position = CGPoint(x:0.5*screenWidth, y:0.215*screenHeight)
        botaoGet2.size = CGSize(width: 119/667*screenWidth, height: 32/375*screenHeight)
        
        botaoGet3.position = CGPoint(x:0.74*screenWidth, y:0.215*screenHeight)
        botaoGet3.size = CGSize(width: 119/667*screenWidth, height: 32/375*screenHeight)
       
        
        addChild(cardCompra1)
        addChild(cardCompra2)
        addChild(cardCompra3)
        addChild(titulo)
        addChild(moeda)
        addChild(botaoGet1)
        addChild(botaoGet2)
        addChild(botaoGet3)
        addChild(botaoVoltar)

        //Background
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = -1
        addChild(background)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            
            if self.atPoint(location) == self.botaoVoltar {
                self.removeAllChildren()
                let homeScene = HomeOptionsScene(size: (self.scene?.size)!)
                self.view?.presentScene(homeScene, transition : SKTransition.crossFade(withDuration: 1.0))
//            let gameScene = StoreViewController()
//            gameScene.dismiss(animated: false, completion: nil)
                
            }
        }
    }
    
    
    
    
    }
    
    
    
    



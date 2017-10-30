//
//  HomeOptions.swift
//  Odessa
//
//  Created by Michelle Beadle on 19/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

class HomeOptionsScene: SKScene {
    
    //Fundo animado
    
    //Public - tem que inicializar caso contrário ele pede para por um init que buga a classe
//    let continueButton = SKSpriteNode(imageNamed: "continue")
    let newGameButton = SKSpriteNode(imageNamed: "newGame")
//    let settingsButton = SKSpriteNode(imageNamed: "options")
    
    override func sceneDidLoad() {
        
        //print("Home Options")
        
        // -- Background --
        let background = SKSpriteNode(imageNamed: "IntroBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = -1
        
        addChild(background)
        
        // -- Buttons --
        
        // A posição dos botão deve ser alterada caso o jogador não tenha nenhum dado salvo
        // no BD pois não existirá o botão "Continue"
        
        //Continue
//        continueButton.position = CGPoint(x: frame.midX ,y: frame.midY + 100)
//        continueButton.zPosition = 1
//        continueButton.size = CGSize(width: 350, height: 50)
//
//        addChild(continueButton)
        
        //New Game
        newGameButton.position = CGPoint(x: frame.midX ,y: frame.midY)
        newGameButton.zPosition = 1
        newGameButton.size = CGSize(width: 350, height: 50)
        
        addChild(newGameButton)
        
        //Settings
//        settingsButton.position = CGPoint(x: frame.midX ,y: frame.midY - 100)
//        settingsButton.zPosition = 1
//        settingsButton.size = CGSize(width: 350, height: 50)
//
//        addChild(settingsButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch touchedNode {
            case continueButton:
                //print("Continue game")
                
                let nextScene = HomePlayerStatusScene(size: frame.size)
                view?.presentScene(nextScene)
                
            case newGameButton:
                print("New game")
                
                let nextScene = GameScene(size: frame.size)
                self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 1.3))
                //                view?.presentScene(nextScene)
                
//            case settingsButton:
//                print("Settings")
            default:
                print("Not an avaliable button")
            }
            
        }
    }

}

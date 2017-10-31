//
//  Home.swift
//  Odessa
//
//  Created by Michelle Beadle on 19/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class HomeScene: SKScene {
    
    //Fundo animado
    //Logo da imagem
    //"Tap to play"
    
    var velocityX:CGFloat = 0.0
    
    
    //    var pigComendo = [SKTexture]()
    //    var pigAndando = [SKTexture]()
    //    var pig = SKSpriteNode()
    //    var pig2 = SKSpriteNode()
    
    override func sceneDidLoad() {
        
        
        let title = SKSpriteNode(imageNamed: "odessa")
        title.position = CGPoint(x: frame.midX, y: frame.midY)
        title.zPosition = 2
        
        
        let background = SKSpriteNode(imageNamed: "IntroBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = 1
        
        addChild(background)
        addChild(title)
        
        print("Home")
        
        let tapLabel = SKLabelNode(fontNamed: "montserrat")
        tapLabel.text = "Tap to play"
        tapLabel.fontSize = 20
        tapLabel.zPosition = 3
        tapLabel.horizontalAlignmentMode = .center
        tapLabel.position = CGPoint(x: frame.midX , y: frame.midY - 100)
        addChild(tapLabel)
        
        let fadeAway = SKAction.fadeOut(withDuration: 0.65)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        
        let sequence = SKAction.sequence([fadeAway, fadeIn])
        let repeatA = SKAction.repeatForever(sequence)
        
        tapLabel.run(repeatA)
        
        
        
        
        
        
        
        
        
        // MARK: Animacoes dos porquinhos
        
        
        //
        //
        //        for i in 1...2 {
        //            pigComendo.append(SKTexture(imageNamed:("porquinho-comendo\(i)")))
        //        }
        //
        //        for i in 1...2 {
        //            pigAndando.append(SKTexture(imageNamed:("pigwalk\(i)")))
        //        }
        //
        //        pig = SKSpriteNode(texture: pigComendo[0])
        //        pig.zPosition = 2
        //        pig.setScale(0.14)
        //
        //        pig2 = SKSpriteNode(texture: pigComendo[0])
        //        pig2.zPosition = 2
        //        pig2.setScale(0.14)
        //
        //
        //
        //        let comendoAction = SKAction.animate(with: pigComendo, timePerFrame: 0.9, resize: true, restore: false)
        //
        //
        //        let andandoAction = SKAction.animate(with: pigAndando, timePerFrame: 0.5, resize: true, restore: false)
        //
        //        let direita = SKAction.move(to: CGPoint(x:frame.midX + 230, y: frame.midY - 139), duration: 6.0)
        //   let esquerda = SKAction.move(to: CGPoint(x:frame.midX - 230, y: frame.midY - 139), duration: 6.0)
        
        //  let leftScale = SKAction.scaleX(to: -0.14, duration: 0)
        //  let rightScale = SKAction.scaleX(to: 0.14, duration: 0)
        
        //
        //         let group = SKAction.group([andandoAction,direita])
        //
        //        pig.position = CGPoint(x: frame.midX - 30, y: frame.midY - 139)
        //        pig2.position = CGPoint(x: frame.midX + 100, y: frame.midY - 139)
        //
        //        let repeatAction = SKAction.repeatForever(comendoAction)
        //     //   let repeatAndando = SKAction.repeat(group, count: 3)
        //
        //        pig.run(repeatAction, withKey: "repeatAction")
        //        addChild(pig)
        //
        //        pig2.run(group, withKey: "repeatAndando")
        //
        //
        //        //pig2.run(repeatAction, withKey: "repeatAction")
        //
        //        addChild(pig2)
        
        
        
        
        
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let sceneOptions = HomeOptionsScene(size: (self.scene?.size)!)
         self.view?.presentScene(sceneOptions, transition: SKTransition.crossFade(withDuration: 0.5))
        //        view?.presentScene(sceneOptions)
    }
    
    
    
}

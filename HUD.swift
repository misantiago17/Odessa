//
//  HUD.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation
import SpriteKit

class HUD {
    
    let HUDNode = SKNode()
    
    var attackButtonNode = SKSpriteNode() // botão de ataque
    var blockButtonNode = SKSpriteNode() // botão de block
    var jumpButtonNode = SKSpriteNode() // botão de pulo
    var specialButtonNode = SKSpriteNode() // botão de pulo
    var setaDirButtonNode = SKSpriteNode() // seta direita
    var setaEsqButtonNode = SKSpriteNode() // seta esquerda
    var barrasNode = SKSpriteNode() // barras
    
    var attackButton = UIButton() // botão de ataque
    var blockButton = UIButton() // botão de block
    var jumpButton = UIButton() // botão pulo
    var setaDirButton = UIButton() // Seta direita
    var setaEsqButton = UIButton() // Seta esquerda
    var barras = UIView() // Barras
    
    func getHUDNode() -> SKNode {
        return HUDNode
    }
    
    func setGestures(scene: GameScene){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scene.Tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scene.Long))
        tapGesture.numberOfTapsRequired = 1
        let attackGesture = UITapGestureRecognizer(target: self, action: #selector(scene.Attack(_:)))
        attackGesture.numberOfTapsRequired = 1
        let jumpGesture = UITapGestureRecognizer(target: self, action: #selector(scene.Jump(_: )))
        
        blockButton.addGestureRecognizer(tapGesture)
        blockButton.addGestureRecognizer(longGesture)
        attackButton.addGestureRecognizer(attackGesture)
        jumpButton.addGestureRecognizer(jumpGesture)
    }
    
    func buttonConfiguration(screenSize: CGSize , camera: SKCameraNode){
        
        HUDNode.inputView?.frame = CGRect(x: camera.position.x, y: camera.position.y, width: camera.frame.size.width, height: camera.frame.size.height)
        
        // Attack Button
        attackButtonNode = SKSpriteNode(imageNamed: "aButton")
        attackButtonNode.zPosition = 2
        attackButtonNode.size = CGSize(width: 70, height: 70)
        attackButtonNode.position = CGPoint(x: screenSize.width/2 * 0.55, y: -(screenSize.height/2 * 0.65))
        
        HUDNode.addChild(attackButtonNode)
        
        let marginAButton = self.attackButtonNode.frame.origin.x + self.attackButtonNode.frame.size.width
        let aButtonHeight = self.attackButtonNode.frame.origin.y + self.attackButtonNode.frame.size.height
        
        // Block Button
        blockButtonNode = SKSpriteNode(imageNamed: "bButton")
        blockButtonNode.zPosition = 2
        blockButtonNode.size = CGSize(width: 70, height: 70)
        blockButtonNode.position = CGPoint(x: marginAButton + 75, y: -(screenSize.height/2 * 0.65))
        
        HUDNode.addChild(blockButtonNode)
        
        // Jump Button
        jumpButtonNode = SKSpriteNode(imageNamed: "sButton")
        jumpButtonNode.zPosition = 2
        jumpButtonNode.size = CGSize(width: 60, height: 60)
        jumpButtonNode.position = CGPoint(x: marginAButton + 18, y: -(screenSize.height/2 * 0.85))
        
        HUDNode.addChild(jumpButtonNode)
        
        // Special Button
        specialButtonNode = SKSpriteNode(imageNamed: "sButton")
        specialButtonNode.zPosition = 2
        specialButtonNode.size = CGSize(width: 60, height: 60)
        specialButtonNode.position = CGPoint(x: marginAButton + 18, y: -(screenSize.height/2 * 0.45))
        
        HUDNode.addChild(specialButtonNode)
        
        // Seta esquerda
        setaEsqButtonNode = SKSpriteNode(imageNamed: "esq")
        setaEsqButtonNode.zPosition = 2
        setaEsqButtonNode.size = CGSize(width: 70, height: 50)
        setaEsqButtonNode.position = CGPoint(x: -(screenSize.width * 0.4), y: aButtonHeight - 35)
        
        HUDNode.addChild(setaEsqButtonNode)
        
        let margiSetaEsquerda = self.setaEsqButtonNode.frame.origin.x + self.setaEsqButtonNode.frame.size.width
        
        // Seta direita
        setaDirButtonNode = SKSpriteNode(imageNamed: "dir")
        setaDirButtonNode.zPosition = 2
        setaDirButtonNode.size = CGSize(width: 70, height: 50)
        setaDirButtonNode.position = CGPoint(x: margiSetaEsquerda + 75, y: aButtonHeight - 35)
        
        HUDNode.addChild(setaDirButtonNode)
        
        
        
        // Barras
        barrasNode = SKSpriteNode(imageNamed: "Barras")
        barrasNode.zPosition = 2
        barrasNode.setScale(0.4)
        barrasNode.size = CGSize(width: (UIImage(named: "Barras")?.size.width)!/2, height: (UIImage(named: "Barras")?.size.height)!/2)
        barrasNode.position = CGPoint(x: screenSize.width - 120, y: screenSize.height + 130)
        
        HUDNode.addChild(barrasNode)
        
    }
    
}

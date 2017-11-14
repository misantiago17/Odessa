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
    var suporteNode = SKSpriteNode() // suporte
    public var pontosLabel: SKLabelNode!
   
    let playerHealthBar = SKSpriteNode() // hp da Odessa

    var attackButton = UIButton() // botão de ataque
    var blockButton = UIButton() // botão de block
    var jumpButton = UIButton() // botão pulo
    var setaDirButton = UIButton() // Seta direita
    var setaEsqButton = UIButton() // Seta esquerda
    var barras = UIView() // Barras
    
    func getHUDNode() -> SKNode {
        return HUDNode
    }
    
    func buttonConfiguration(screenSize: CGSize , camera: SKCameraNode){
        
        HUDNode.inputView?.frame = CGRect(x: camera.position.x, y: camera.position.y, width: camera.frame.size.width, height: camera.frame.size.height)
        
        // Attack Button
        attackButtonNode = SKSpriteNode(imageNamed: "aButton")
        attackButtonNode.zPosition = 2
        attackButtonNode.size = CGSize(width: 70, height: 70)
        attackButtonNode.position = CGPoint(x: screenSize.width/2 * 0.50, y: -(screenSize.height/2 * 0.62))
        
        HUDNode.addChild(attackButtonNode)
        
        let marginAButton = self.attackButtonNode.frame.origin.x + self.attackButtonNode.frame.size.width
        let aButtonHeight = self.attackButtonNode.frame.origin.y + self.attackButtonNode.frame.size.height
        
        // Block Button
        blockButtonNode = SKSpriteNode(imageNamed: "bButton")
        blockButtonNode.zPosition = 2
        blockButtonNode.size = CGSize(width: 70, height: 70)
        blockButtonNode.position = CGPoint(x: marginAButton + 75, y: -(screenSize.height/2 * 0.62))
        
        HUDNode.addChild(blockButtonNode)
        
        // Jump Button
        jumpButtonNode = SKSpriteNode(imageNamed: "jButton")
        jumpButtonNode.zPosition = 2
        jumpButtonNode.size = CGSize(width: 60, height: 60)
        jumpButtonNode.position = CGPoint(x: marginAButton + 18, y: -(screenSize.height/2 * 0.82))
        
        
        HUDNode.addChild(jumpButtonNode)
        
        // Special Button
        specialButtonNode = SKSpriteNode(imageNamed: "sButton")
        specialButtonNode.zPosition = 2
        specialButtonNode.size = CGSize(width: 60, height: 60)
        specialButtonNode.position = CGPoint(x: marginAButton + 18, y: -(screenSize.height/2 * 0.42))
        
        HUDNode.addChild(specialButtonNode)
    
        
        // Barras
        
        suporteNode = SKSpriteNode(imageNamed: "SuporteHPSP")
        suporteNode.setScale(0.3)
        suporteNode.position = CGPoint(x: screenSize.width/2 - 430, y: -(screenSize.height/2) + 290)
        suporteNode.zPosition = 2
        HUDNode.addChild(suporteNode)

        
        // Contador de Moedas
        
        pontosLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        pontosLabel.text = "0"
        pontosLabel.horizontalAlignmentMode = .right
        pontosLabel.position = CGPoint(x: marginAButton * 1.3, y: -(screenSize.height/2) + 290)
        pontosLabel.fontSize = 15
        pontosLabel.zPosition = 2
        pontosLabel.color = UIColor.white
        
        HUDNode.addChild(pontosLabel)
        
        // Hp Odessa
        
        playerHealthBar.setScale(0.3)
        playerHealthBar.zPosition = 3
        playerHealthBar.position = CGPoint(x: screenSize.width/2 - 421, y: -(screenSize.height/2) + 288)
        HUDNode.addChild(playerHealthBar)

    }
    
}

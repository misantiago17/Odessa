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
    
    let setaDireita = SKSpriteNode(imageNamed: "sdir")
    let setaEsquerda = SKSpriteNode(imageNamed: "sesq")
    let setaCima = SKSpriteNode(imageNamed: "scima")
    let setaBaixo = SKSpriteNode(imageNamed: "sbaixo")
    
    var attackButton = UIButton() // botão de ataque
    var blockButton = UIButton() // botão de block
    
    func getHUDNode() -> SKNode {
        return HUDNode
    }
    
    func setGestures(scene: GameScene){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scene.Tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scene.Long))
        tapGesture.numberOfTapsRequired = 1
        
        let attackGesture = UITapGestureRecognizer(target: self, action: #selector(scene.Attack(_:)))
        attackGesture.numberOfTapsRequired = 1
        
        blockButton.addGestureRecognizer(tapGesture)
        blockButton.addGestureRecognizer(longGesture)
        attackButton.addGestureRecognizer(attackGesture)
    }
    
    func buttonConfiguration(scene: GameScene){
        
        HUDNode.inputView?.frame = CGRect(x: scene.position.x, y: scene.position.y, width: scene.size.width, height: scene.size.height)
        
        // Attack Button
        attackButton = UIButton(frame: CGRect(x: 0, y:0, width: 95, height: 95))
        attackButton.backgroundColor = UIColor.clear
        attackButton.center =  CGPoint(x: (scene.view?.frame.size.width)!/2 + 145  , y: (scene.view?.frame.size.height)!/2 + 105)
        scene.view?.addSubview(attackButton)
        attackButton.setImage( UIImage(named: "button") , for: .normal)
        
        HUDNode.inputView?.addSubview(attackButton)
        
        // Block Button
        blockButton = UIButton(frame: CGRect(x: 0, y:0, width: 50, height: 50))
        blockButton.backgroundColor = UIColor.clear
        blockButton.center =  CGPoint(x: (scene.view?.frame.size.width)!/2 + 230  , y: (scene.view?.frame.size.height)!/2 + 60)
        blockButton.setImage(UIImage(named: "S"), for: .normal)
        
        HUDNode.inputView?.addSubview(attackButton)
        
    }
    
}

//
//  Movimentacao.swift
//  Odessa
//
//  Created by Michelle Beadle on 12/10/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import Foundation
import SpriteKit

class Movimentacao {
    
    var jumpAction = SKAction()
    var attackAction = SKAction()
    var idleAction = SKAction()
    var blockAction = SKAction()
    var longBlockAction = SKAction()
    var jumpSequence = SKAction()
    
    var spriteArray = [SKTexture]() //Odessa Run
    var attackArray = [SKTexture]() //Odessa Attack
    var lancaAttack = [SKTexture]() //Lança Attack
    var blockArray = [SKTexture]() //Odessa Block
    var lancaBlock = [SKTexture]() //Lança Block
    var longBlockArray = [SKTexture]() //Odessa long Block
    var idleArray = [SKTexture]() //Odessa Idle
    
    // Jump animation
    var impulsoArray = [SKTexture]()
    var puloCimaArray = [SKTexture]()
    var puloBaixoArray = [SKTexture]()
    var aterrissagemArray = [SKTexture]()
    
    // Velocity
    var velocityX:CGFloat = 0.0
    var velocityY:CGFloat = 0.0
    
    // Action
    var jumpUp = SKAction()
    var fallBack = SKAction()
    var impulso =  SKAction()
    var puloCima = SKAction()
    var puloBaixo = SKAction()
    
    
    func setMovements() {
        
        //MARK: Odessa Attack
        for i in 1...7 {
            attackArray.append(SKTexture(imageNamed: "odessa-attackframe\(i)"))
        }
        
        //MARK: Lança Attack
        for i in 1...7 {
            lancaAttack.append(SKTexture(imageNamed: "lanca-odessa-attackframe\(i)"))
        }
        
        //MARK: Odessa Block
        for i in 1...2 {
            blockArray.append(SKTexture(imageNamed: "Odessa-block-frame\(i)"))
        }
        
        //MARK: Lança Block
        for i in 1...2 {
            lancaBlock.append(SKTexture(imageNamed: "Lanca-Odessa-block-frame\(i)"))
        }
        
        //MARK: Odessa Long Block
        for i in 1...2 {
            longBlockArray.append(SKTexture(imageNamed: "Odessa-block-hold-frame\(i)"))
        }
        
        // MARK: Odessa Run
        for i in 1...3 {
            spriteArray.append(SKTexture(imageNamed: "odessaRunframe\(i)"))
        }
        
        //MARK:Idle
        for i in 1...4 {
            idleArray.append(SKTexture(imageNamed: "Odessa-idle-frame\(i)"))
        }
        
        //MARK: Odessa Jump
        
        for i in 1...2 {
            impulsoArray.append(SKTexture(imageNamed: "odessaJumpframe\(i)"))
        }
        
        puloCimaArray.append(SKTexture(imageNamed: "odessaJumpframe3"))
        // puloBaixoArray.append(textureAtlas.textureNamed("odessaJumpframe4"))
        
        for i in 4...6 {
            puloBaixoArray.append(SKTexture(imageNamed: "odessaJumpframe\(i)"))
        }
        
        puloBaixoArray.append(SKTexture(imageNamed: "odessa-attackframe1"))
        //  aterrissagemArray.append(textureAtlas.textureNamed("odessaJumpframe6"));
        
    }
    
    func setAction(player: SKSpriteNode, velocity: CGFloat){
        
        var impulsoArray = [SKTexture]()
        var puloCimaArray = [SKTexture]()
        var puloBaixoArray = [SKTexture]()
        
        for i in 1...2 {
            impulsoArray.append(SKTexture(imageNamed: "odessaJumpframe\(i)"))
        }
    
        puloCimaArray.append(SKTexture(imageNamed: "odessaJumpframe3"))
    
        for i in 4...6 {
            puloBaixoArray.append(SKTexture(imageNamed: "odessaJumpframe\(i)"))
        }
    
        jumpUp = SKAction.moveBy(x: 0, y: 240, duration: 0.3)
        fallBack = SKAction.moveBy(x: 0, y: 0, duration: 0.3)
    
        let impulso = SKAction.animate(with: impulsoArray, timePerFrame: 0.1)
        let puloCima = SKAction.animate(with: puloCimaArray, timePerFrame: 0.05)
        let puloBaixo = SKAction.animate(with: puloBaixoArray, timePerFrame: 0.10)
        let group = SKAction.group([puloBaixo, fallBack])
        jumpAction = SKAction.sequence([impulso,puloCima, jumpUp, group])
        
        
        
    }
    
}

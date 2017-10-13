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
    
    var spriteArray = [SKTexture]()
    var attackArray = [SKTexture]()
    var jumpArray = [SKTexture]()
    var idleArray = [SKTexture]()
    var blockArray = [SKTexture]()
    var longBlockArray = [SKTexture]()
    
    var velocityX:CGFloat = 0.0
    var velocityY:CGFloat = 0.0
    
    let jumpUp = SKAction.moveBy(x: 0, y: 200, duration: 0.3)
    let fallBack = SKAction.moveBy(x: 0, y: -200, duration: 0.3)
    
    func setMovements() {
        
    }
    
}

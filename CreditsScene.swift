//
//  CreditsScene.swift
//  Odessa
//
//  Created by João Rafael de Aquino on 27/11/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class CreditsScene: SKScene {

    let botaoVoltar = SKSpriteNode(imageNamed: "voltar")
    
    override func sceneDidLoad() {
    
    botaoVoltar.position = CGPoint(x: 0.1*screenWidth, y: 0.86*screenHeight)
    botaoVoltar.size = CGSize(width: 12.5/667*screenWidth, height: 25/375*screenHeight)
    
    }
    
    
    
}

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
    
    override func sceneDidLoad() {
        
        let background = SKSpriteNode(imageNamed: "telainicial")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = 1
        //background.size = CGSize(width: (self.view?.frame.size.width)!, height: (self.view?.frame.size.height)!)
        
        addChild(background)
        
        print("Home")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("AAAAAAAAAA")
    }

}

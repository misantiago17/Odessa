//
//  CreditScene.swift
//  
//
//  Created by João Rafael de Aquino on 16/11/17.
//

import UIKit
import GameplayKit

class CreditScene: SKScene {
    
    override func sceneDidLoad() {
    
    //Background
    let background = SKSpriteNode(imageNamed: "IntroBackground")
    background.position = CGPoint(x: frame.midX, y: frame.midY)
    background.size = self.frame.size
    background.zPosition = -1
    addChild(background)
        
    //Texto Centro
    let creditsText = SKSpriteNode(imageNamed: "creditsText")
    creditsText.position = CGPoint(x:331/667*screenWidth, y:167*377)
    creditsText.size = CGSize(width: 331/667*screenWidth, height: 229/375*screenHeight)
    addChild(creditsText)
        
    //Botão Voltar
    let botaoVoltar = SKSpriteNode(imageNamed: "voltar")
    botaoVoltar.position = CGPoint(x: 0.1*screenWidth, y: 0.86*screenHeight)
    botaoVoltar.size = CGSize(width: 12.5/667*screenWidth, height: 25/375*screenHeight)
    addChild(botaoVoltar)
        
    //Titulo Creditos
     let titulo = SKSpriteNode(imageNamed: "creditsTitle")
    titulo.position = CGPoint(x: 0.5*screenWidth, y: 0.86*screenHeight)
    titulo.size = CGSize(width: 86/667*screenWidth, height: 31/375*screenHeight)
    addChild(titulo)
    
    
        
        
    
    }
    

}

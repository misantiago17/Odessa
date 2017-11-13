//
//  Home.swift
//  Odessa
//
//  Created by Michelle Beadle on 19/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

class HomeScene: SKScene {
    
    //Fundo animado
    //Logo da imagem
    //"Tap to play"
    
    var velocityX:CGFloat = 0.0
    
    let newGameButton = SKSpriteNode(imageNamed: "newGame")
    var pigComendo = [SKTexture]()
    var bandeiraGrande = [SKTexture]()
    var primeiraNuvem = [SKTexture]()
    var segundaNuvem = [SKTexture]()
    var terceiraNuvem = [SKTexture]()
    //    var pigAndando = [SKTexture]()
    var pig = SKSpriteNode()
    var pig2 = SKSpriteNode()
    var bandeirao = SKSpriteNode()
    var bandeirao2 = SKSpriteNode()
    var nuvem1 = SKSpriteNode()
    var nuvem2 = SKSpriteNode()
    var nuvem3 = SKSpriteNode()
    var title = SKSpriteNode()
    var tapLabel = SKLabelNode()
    var isNewGame = false
    
    override func sceneDidLoad() {
        
        
        title = SKSpriteNode(imageNamed: "odessa")
        title.position = CGPoint(x: frame.midX, y: frame.midY)
        title.zPosition = 2
        
        
        let background = SKSpriteNode(imageNamed: "IntroBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size
        background.zPosition = 1
        
        let backgroundFloor = SKSpriteNode(imageNamed: "IntroFloor")
        backgroundFloor.position = CGPoint(x: frame.midX, y: screenHeight*0.01)
        backgroundFloor.size = CGSize(width: screenWidth, height: screenWidth/10)
        backgroundFloor.zPosition = 1.5
        
        let colunaEsquerda = SKSpriteNode(imageNamed: "coluna2")
        colunaEsquerda.position = CGPoint(x: screenWidth*0.05, y: screenHeight*0.25)
        colunaEsquerda.setScale(0.5)
        colunaEsquerda.zPosition = 1.4
        
        let colunaMeio = SKSpriteNode(imageNamed: "coluna3")
        colunaMeio.position = CGPoint(x: screenWidth*0.80, y: screenHeight*0.25)
        colunaMeio.setScale(0.5)
        colunaMeio.zPosition = 1.4
        
        let colunaDireita = SKSpriteNode(imageNamed: "coluna1")
        colunaDireita.position = CGPoint(x: screenWidth*0.95, y: screenHeight*0.25)
        colunaDireita.setScale(0.5)
        colunaDireita.zPosition = 1.4
        
        addChild(background)
        addChild(backgroundFloor)
        addChild(title)
        addChild(colunaEsquerda)
        addChild(colunaMeio)
        addChild(colunaDireita)
        
        tapLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
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
        for i in 1...2 {
            pigComendo.append(SKTexture(imageNamed:("porquinho-comendo\(i)")))
        }
        //
        //        for i in 1...2 {
        //            pigAndando.append(SKTexture(imageNamed:("pigwalk\(i)")))
        //        }
        //
        for i in 1...6 {
            bandeiraGrande.append(SKTexture(imageNamed:("Bandeira1frame\(i)")))
        }
        
        for i in 1...4 {
            primeiraNuvem.append(SKTexture(imageNamed:("cloud1frame\(i)")))
        }
        
        for i in 1...4 {
            segundaNuvem.append(SKTexture(imageNamed:("cloud2frame\(i)")))
        }
        
        for i in 1...4 {
            terceiraNuvem.append(SKTexture(imageNamed:("cloud3frame\(i)")))
        }
        
        pig = SKSpriteNode(texture: pigComendo[0])
        pig.zPosition = 2
        pig.setScale(0.14)
        //
        pig2 = SKSpriteNode(texture: pigComendo[0])
        pig2.zPosition = 2
        pig2.setScale(0.14)
        //
        //
        bandeirao = SKSpriteNode(texture: bandeiraGrande[0])
        bandeirao.zPosition = 1.4
        bandeirao.setScale(0.35)
        //
        bandeirao2 = SKSpriteNode(texture: bandeiraGrande[0])
        bandeirao2.zPosition = 1.4
        bandeirao2.setScale(0.35)
        //
        nuvem1 = SKSpriteNode(texture: primeiraNuvem[0])
        nuvem1.zPosition = 1.4
        nuvem1.setScale(0.35)
        //
        nuvem2 = SKSpriteNode(texture: segundaNuvem[0])
        nuvem2.zPosition = 1.4
        nuvem2.setScale(0.35)
        //
        nuvem3 = SKSpriteNode(texture: terceiraNuvem[0])
        nuvem3.zPosition = 1.4
        nuvem3.setScale(0.35)
        //
        let comendoAction = SKAction.animate(with: pigComendo, timePerFrame: 0.9, resize: true, restore: false)
        let balancarAction = SKAction.animate(with: bandeiraGrande, timePerFrame: 0.26, resize: true, restore: false)
        let mexerNuvem = SKAction.animate(with: primeiraNuvem, timePerFrame: 1, resize: true, restore: false)
        let mexerNuvem2 = SKAction.animate(with: segundaNuvem, timePerFrame: 1, resize: true, restore: false)
        let mexerNuvem3 = SKAction.animate(with: terceiraNuvem, timePerFrame: 1, resize: true, restore: false)
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
        pig.position = CGPoint(x: screenWidth*0.3, y: screenHeight*0.075)
        pig2.position = CGPoint(x: screenWidth*0.6, y: screenHeight*0.075)
        //
        bandeirao.position = CGPoint(x: screenWidth*0.15, y: screenHeight*0.287)
        bandeirao2.position = CGPoint(x: screenWidth*0.90, y: screenHeight*0.257)
        //
        nuvem1.position = CGPoint(x: screenWidth*0.01 - 100, y: screenHeight*0.8)
        nuvem1.alpha = 0.85
        nuvem2.position = CGPoint(x: screenWidth*0.22, y: screenHeight*0.85)
        nuvem2.alpha = 0.85
        nuvem3.position = CGPoint(x: screenWidth*0.65, y: screenHeight*0.75)
        nuvem3.alpha = 0.85
        
        let repeatAction = SKAction.repeatForever(comendoAction)
        let leftRepeat = SKAction.scaleX(to: -0.14, duration: 0)
        let groupAction = SKAction.group([repeatAction, leftRepeat])
        
        let nuvemAction = SKAction.repeatForever(mexerNuvem)
        let mudarLadoNuvem = SKAction.scaleX(to: -0.35, duration: 0)
        let moverNuvem = SKAction.moveTo(x: screenWidth*1.2, duration: 240)
        let groupNuvemAction = SKAction.group([nuvemAction, mudarLadoNuvem, moverNuvem])
        
        let nuvem2Action = SKAction.repeatForever(mexerNuvem2)
        let moverNuvem2 = SKAction.moveTo(x: screenWidth*1.5, duration: 240)
        let groupNuvem2Action = SKAction.group([nuvem2Action, mudarLadoNuvem, moverNuvem2])
        
        let nuvem3Action = SKAction.repeatForever(mexerNuvem3)
        let moverNuvem3 = SKAction.moveTo(x: screenWidth*1.8, duration: 240)
        let groupNuvem3Action = SKAction.group([nuvem3Action, mudarLadoNuvem, moverNuvem3])
        
        let repeatBandeira = SKAction.repeatForever(balancarAction)
        //     //   let repeatAndando = SKAction.repeat(group, count: 3)
        //
        pig.run(repeatAction)
        addChild(pig)
        //
        pig2.run(groupAction)
        addChild(pig2)
        //
        bandeirao.run(repeatBandeira)
        addChild(bandeirao)
        //
        bandeirao2.run(repeatBandeira)
        addChild(bandeirao2)
        
        nuvem1.run(groupNuvemAction)
        addChild(nuvem1)
        
        nuvem2.run(groupNuvem2Action)
        addChild(nuvem2)
        
        nuvem3.run(groupNuvem3Action)
        addChild(nuvem3)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            switch touchedNode {
            case newGameButton:
                removeAllActions()
                removeAllChildren()
                let nextScene = GameScene(size: frame.size)
                self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 1.0))
            default:
                if isNewGame == false{
                    
                    title.removeFromParent()
                    tapLabel.removeFromParent()
                    newGameButton.position = CGPoint(x: frame.midX ,y: frame.midY)
                    newGameButton.zPosition = 2.5
                    newGameButton.size = CGSize(width: 350, height: 50)
                    addChild(newGameButton)
                    isNewGame = true
                    
                }
            }
            
        }
        
    }
    
}

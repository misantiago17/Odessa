//
//  GameScene.swift
//  Odessa
//
//  Created by Michelle Beadle on 15/09/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftyJSON

class GameScene: SKScene {
    
    //Oraganização: precisa de coisa pra caralho
    
    //Public
    // - Fundo animado
    var background = SKSpriteNode()
    var player: Player = Player(nome: "Odessa", vida: 100, velocidade: 100.0, defesa: 30, numVida: 3, ataqueEspecial: 75)
    var playerNode = SKSpriteNode()
    // - Inimigos
    var mapa: Mapa?
    var HUDNode = HUD()
    var movements = Movimentacao()
    // - Vida
    // - Especial
    // - BtnDeAtaque1
    // - BtnDeAtaque2
    // - Joystick
    // - Moedas
    
    private let cam = SKCameraNode()
    // Criar uma função responsavel por unir cada bloco de chão com sua largura sem falhas e retorna um único sprite com todo o chão do nível
    
    override func sceneDidLoad() {
        
        // Mapa
        mapa = createMap()
        let floor = organizeMap()
        floor.physicsBody?.isDynamic = false
        addChild(floor)
        
        // Player
        playerNode = SKSpriteNode(texture: SKTexture(image: UIImage(named: "Odessa-idle-frame1")!))
        playerNode.position = CGPoint(x: 100, y: 300)
        playerNode.setScale(0.48)
        playerNode.physicsBody = SKPhysicsBody(texture: playerNode.texture! , size: CGSize(width: playerNode.size.width, height: playerNode.size.height))
        
        addChild(playerNode)
        
        // Camera
        self.camera = cam
        
        // Background
        background = SKSpriteNode(texture: SKTexture(imageNamed: "bg"))
        
        // Set gestures into HUD buttons
        HUDNode.setGestures(scene: self)
        HUDNode.buttonConfiguration(scene: self)
        let hud = HUDNode.getHUDNode()
        
        addChild(hud)
        view?.addSubview(hud.inputView!)
        
        // Set animation movements
        movements.setMovements()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        // Camera
        cam.position = playerNode.position
    }
    
    // Gestures
    
    func Attack(_ sender: UIGestureRecognizer) {
        
//        let animateAction = SKAction.animate(with: self.attackArray, timePerFrame: 0.1, resize: true, restore: false)
//        let repeatAction = SKAction.repeat(animateAction, count: 1)
//        self.player.run(repeatAction, withKey: "repeatAction")
        
        //        if sender.state == .began {
        //
        //            print("UIGestureRecognizerStateEnded")
        //            player.removeAction(forKey: "repeatAction")
        //
        //            let animateAction = SKAction.animate(with: self.idleArray, timePerFrame: 0.2, resize: true, restore: false)
        //            let repeatAction = SKAction.repeatForever(animateAction)
        //            self.player.run(repeatAction)
        //
        //        }
    }

    func Tap(_ sender: UIGestureRecognizer) {
        print("tap")
//        let animateAction = SKAction.animate(with: self.blockArray, timePerFrame: 0.1, resize: true, restore: false)
//        let repeatAction = SKAction.repeat(animateAction, count: 1)
//        self.player.run(repeatAction, withKey: "repeatAction")
        
        //        if sender.state == .ended {
        //
        //            print("UIGestureRecognizerStateEnded")
        //            player.removeAction(forKey: "repeatAction")
        //
        //            let animateAction = SKAction.animate(with: self.idleArray, timePerFrame: 0.2, resize: true, restore: false)
        //            let repeatAction = SKAction.repeatForever(animateAction)
        //            self.player.run(repeatAction)
        //            
        //        }
        
        
    }
    
    func Long(_ sender: UIGestureRecognizer) {
//        print("long")
//        let animateAction = SKAction.animate(with: self.longBlockArray, timePerFrame: 0.1, resize: true, restore: false)
//        let repeatAction = SKAction.repeatForever(animateAction)
//        self.player.run(repeatAction, withKey: "repeatAction")
//        
//        if sender.state == .ended {
//            
//            print("UIGestureRecognizerStateEnded")
//            player.removeAction(forKey: "repeatAction")
//            
//            let animateAction = SKAction.animate(with: self.idleArray, timePerFrame: 0.2, resize: true, restore: false)
//            let repeatAction = SKAction.repeatForever(animateAction)
//            self.player.run(repeatAction)
//            
    }

    
    // Cria Mapa
    
    func createMap() -> Mapa {
        
        let modulosIDs: [Int] = randomizeModules()
        var modulos: [ModuloMapa] = []
        
        for ID in modulosIDs {
            let modulo = Reader().GetModule(ModuleID: ID)
            modulos.append(modulo)
        }
        
        let map = Mapa(Modulos: modulos)
        
        return map
    }
    
    //modulo pode repetir mas não pode se repetir em sequência
    func randomizeModules() -> [Int] {
        
        var sequenciaModulos: [Int] = []
        
        for i in 0...9 {
            
            var item = Int(arc4random_uniform(9))
            
            if (!sequenciaModulos.isEmpty) {
                while(sequenciaModulos[i-1] == item + 1){
                    item = Int(arc4random_uniform(9))
                }
            }
            
            sequenciaModulos.append(item + 1)
        }
        
        return sequenciaModulos
    }
    
    // Arruma os sprites do mapa
    
    func organizeMap() -> SKNode {
        
        var floor = SKNode()
        var floorSegments: [SKSpriteNode] = []
        var i: Int = 0
        
        for module in (mapa?.Modulos)! {
            
            let floorModule = SKSpriteNode(texture: SKTexture(image: module.imagemCenario))
            floorModule.position.x = floor.calculateAccumulatedFrame().size.width + (floorModule.size.width/2)
            floorModule.position.y = SetYFloorPosition(floor: floorModule)
            //floorModule.position = CGPoint(x: floor.calculateAccumulatedFrame().size.width + (floorModule.size.width/2), y: 200)
            //floorModule.position = CGPoint(x: 200 + offSet, y: 200)
            floorModule.physicsBody = SKPhysicsBody(texture: floorModule.texture!, size: (floorModule.texture?.size())!)
            floorModule.physicsBody?.affectedByGravity = false
            floorModule.physicsBody?.isDynamic = false
            
            floorSegments.append(floorModule)
            
            floor.addChild(floorModule)
            
            if (i > 0){
                //SKPhysicsJointPin.joint(withBodyA: floorSegments[i-1].physicsBody!, bodyB: floorSegments[i].physicsBody!, anchor: CGPoint(x: 1.0, y: 1.0))
               // SKPhysicsJointPin.joint(withBodyA: floorSegments[i].physicsBody!, bodyB: floorSegments[i-1].physicsBody!, anchor: CGPoint(x: 0.0, y: 1.0))
                SKPhysicsJointFixed.joint(withBodyA: floorSegments[i-1].physicsBody!, bodyB: floorSegments[i].physicsBody!, anchor: CGPoint(x: 0.5, y: 0.5))
            }
            
            //floor.addChild(floorModule)

            i+=1
        }
        
        return floor
    }
    
    func SetYFloorPosition(floor: SKSpriteNode) -> CGFloat {
        let yPosition: Float = Float((frame.size.height)/5)
        let originalYPosition: Float = Float(floor.size.height)
        var newPosition: Float
        
        if (originalYPosition > yPosition) {
            newPosition = yPosition + Float((floor.size.height/2) - 442)
        } else if (originalYPosition < yPosition) {
            newPosition = yPosition - originalYPosition
        } else {
            newPosition = yPosition
        }
        
        print(newPosition)
        
        return CGFloat(newPosition)
    }

}


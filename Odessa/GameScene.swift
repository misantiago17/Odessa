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
    
    //falta fazer pulo conforme a movimentação da odessa. Por enquanto tem soh pulo para direita
    //falta fazer considção de derrota e game over
    //delay no botão de movimentação
    
    
    // pular mais baixo// repetir escudo no ar mais uma vez
    //pular mais longe

    //Oraganização: precisa de coisa pra caralho
    
    //Public
    // - Fundo animado
    var background = SKSpriteNode()
    var player: Player = Player(nome: "Odessa", vida: 100, velocidade: 100.0, defesa: 30, numVida: 3, ataqueEspecial: 75)
    var playerNode = SKSpriteNode()
    var hud = SKNode()
    var inimigosNode = [SKSpriteNode()]
    
    
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
   
    //movimento
    var velocityX:CGFloat = 0.0
    var velocityY:CGFloat = 0.0
    
    override func sceneDidLoad() {
        
        // Mapa
        mapa = createMap()
        let floor = organizeMap()
        floor.physicsBody?.isDynamic = false
        addChild(floor)
        
        // Inicializa as animações
        movements.setMovements()
        movements.setAction(player: playerNode)
        
        // Player
        playerNode = SKSpriteNode(texture: movements.spriteArray[0])
        playerNode.setScale(0.34)
        playerNode.position = CGPoint(x: 100, y: 400)
        // criar uma função pra pegar a textura atual da odessa e mudar o physics body conforme ela no update
        playerNode.physicsBody = SKPhysicsBody(texture: playerNode.texture! , size: CGSize(width: playerNode.size.width, height: playerNode.size.height))
        playerNode.zPosition = 1
        playerNode.physicsBody?.allowsRotation = false
        addChild(self.playerNode)
        
        // Background
        background = SKSpriteNode(texture: SKTexture(imageNamed: "fundo"))
        background.zPosition = -2
        background.setScale(0.5)
        
        // Set gestures into HUD buttons
        HUDNode.buttonConfiguration(screenSize: UIScreen.main.bounds.size, camera: cam)
        hud = HUDNode.getHUDNode()
        
        print(UIScreen.main.bounds.size.width)
        print(self.frame.size.width)
        //hud.addChild(HUDNode.HUDNode)
        
        //addChild(hud)
        //view?.addSubview(hud.inputView!)
        
        // Camera
        

    }
    
     override func didMove(to view: SKView) {

        
        // MARK: Camera        
        let center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        
        cam.position = center
        //addChild(cam)
        camera = cam
        
        addChild(cam)
        cam.addChild(hud)
        cam.addChild(background)

        //cam.addChild(hud)
    }
    
    // Handle Touches
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            self.touchDown(atPoint: t.location(in: cam))
            let location = t.location(in: cam)
            
            var banana = 1
            if (HUDNode.setaDirButtonNode.frame.contains(location)){

                let animateAction = SKAction.animate(with: movements.spriteArray, timePerFrame: 0.2, resize: true, restore: false)
                let repeatAction = SKAction.repeatForever(animateAction)


                let rightScale = SKAction.scaleX(to: 0.35, duration: 0)
                let group = SKAction.group([repeatAction, rightScale])

                self.playerNode.run(group, withKey: "repeatAction")

                velocityX = (playerNode.position.x - playerNode.position.x + 50)/20

                self.playerNode.position.x += velocityX
                
                
            } else if (HUDNode.setaEsqButtonNode.frame.contains(location)){

                let animateAction = SKAction.animate(with: movements.spriteArray, timePerFrame: 0.2, resize: true, restore: false)
                let repeatAction = SKAction.repeatForever(animateAction)

                let leftScale = SKAction.scaleX(to: -0.35, duration: 0)
                let group = SKAction.group([repeatAction, leftScale])

                self.playerNode.run(group, withKey: "repeatAction")

                velocityX = (playerNode.position.x - playerNode.position.x - 50)/20

                self.playerNode.position.x += velocityX

            }
            
            if (HUDNode.attackButtonNode.frame.contains(location)){
                
                let animateAction = SKAction.animate(with: movements.attackArray, timePerFrame: 0.1, resize: true, restore: false)
                let repeatAction = SKAction.repeat(animateAction, count: 1)
                self.playerNode.run(repeatAction, withKey: "repeatAction")
            }
            
            if (HUDNode.blockButtonNode.frame.contains(location)){
                
                //////////////////////////////////////// FAZER O LONG TAP AQUI
                print("block")
                let animateAction = SKAction.animate(with: movements.blockArray, timePerFrame: 0.1, resize: true, restore: false)
                let repeatAction = SKAction.repeat(animateAction, count: 1)
                self.playerNode.run(repeatAction, withKey: "repeatAction")
            }
            
            if (HUDNode.jumpButtonNode.frame.contains(location)){
                
                let repeatAction = SKAction.repeat(movements.jumpAction, count: 1)
                self.playerNode.run(repeatAction, withKey: "repeatAction")
            }

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: cam))
            
            playerNode.removeAction(forKey: "repeatAction")
            velocityX = 0
            let animateAction = SKAction.animate(with: movements.idleArray, timePerFrame: 0.2, resize: true, restore: false)
            let repeatAction = SKAction.repeatForever(animateAction)
            self.playerNode.run(repeatAction)
            
        }
        
       
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        // Camera
        cam.position = playerNode.position
        
         self.playerNode.position.x += velocityX
        
        // Game Over
        if (playerNode.position.y < -239){
            
            let nextScene = GameOverScene(size: self.scene!.size)
            nextScene.scaleMode = self.scaleMode
            nextScene.backgroundColor = UIColor.black
            self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 1.5))
        }
    }
    
    // Place Enemies in modules
    
    func placeEnemy(modulo: ModuloMapa, spriteMod: SKSpriteNode) {
        
        var moduleWaves = Reader().GetModuleSets(ModuleID: modulo.IDModulo)
        var item = Int(arc4random_uniform(UInt32(moduleWaves.count) - 1))
        
        for inimigo in moduleWaves[item].inimigos {
            
            let texture = SKTexture(image: UIImage(named: inimigo.imgName)!)
            
            var inimigoNode = SKSpriteNode(texture: texture)
            inimigoNode.position = CGPoint(x: Double(inimigo.posInModuleX!), y: Double(inimigo.posInModuleY!))
            inimigoNode.zPosition = 1
            inimigoNode.setScale(0.34)
            inimigoNode.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
            inimigoNode.physicsBody?.allowsRotation = false
            
            inimigosNode.append(inimigoNode)
            //spriteMod.addChild(inimigoNode)
        
        }
        
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
            floorModule.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floorModule.frame.width, height: floorModule.frame.height))
            floorModule.physicsBody = SKPhysicsBody(texture: floorModule.texture!, size: (floorModule.texture?.size())!)
            floorModule.physicsBody?.affectedByGravity = false
            floorModule.physicsBody?.isDynamic = false
            
            placeEnemy(modulo: module, spriteMod: floorModule)
            
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
        
        //print(newPosition)
        
        return CGFloat(newPosition)
    }
    
    func Long(_ sender: UIGestureRecognizer) {

        let animateAction = SKAction.animate(with: movements.longBlockArray, timePerFrame: 0.1, resize: true, restore: false)
        let repeatAction = SKAction.repeatForever(animateAction)
        self.playerNode.run(repeatAction, withKey: "repeatAction")

        if sender.state == .ended {

            print("UIGestureRecognizerStateEnded")
            playerNode.removeAction(forKey: "repeatAction")

            let animateAction = SKAction.animate(with: movements.idleArray, timePerFrame: 0.3, resize: true, restore: false)
            let repeatAction = SKAction.repeatForever(animateAction)
            self.playerNode.run(repeatAction)
        }
 
    }  
    
}


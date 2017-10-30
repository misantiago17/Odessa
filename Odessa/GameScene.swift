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
    var playerNode = SKSpriteNode(texture: SKTexture(imageNamed: "Odessa-idle-frame1"))
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
    
    
    
    var location = CGPoint(x: 0, y: 0)
//    var touchStarted: TimeInterval?
//    let longTapTime: TimeInterval = 0.5

    var fingerIsTouching:Bool = false
    
    //Joystick
    var joystick: JoyStickView?
    var angle = CGFloat(0)
    var displacemet = CGFloat(0)
    
    //Current Frame
    var currentOdessaRunSprite = 0
    var currentOdessaIdleSprite = 0
    
    //Joystick
    var joystickInUse = false
    
    //Timer da Vassoura
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var dt = 0.00
    var stopTimer : Bool!
    
    
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
        //playerNode = SKSpriteNode(texture: movements.spriteArray[0])
        //playerNode = SKSpriteNode(texture: SKTexture(imageNamed: "Odessa-idle-frame1"))
        //playerNode.setScale(0.34)
        playerNode.size = CGSize(width: size.height/4, height: size.height/4)
        playerNode.position = CGPoint(x: 100, y: 400)
        
        // criar uma função pra pegar a textura atual da odessa e mudar o physics body conforme ela no update
        //playerNode.physicsBody = SKPhysicsBody(texture: playerNode.texture! , size: CGSize(width: playerNode.size.width, height: playerNode.size.height))
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 32.5,
                                                                            height: 60))
        
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
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
        
        // MARK: joystick
        let rect = view.frame
        let size = CGSize(width: 80.0, height: 80.0)
        let joystickFrame = CGRect(origin: CGPoint(x: 40.0,
                                                   y: (rect.height - size.height - 25.0)),
                                   size: size)
        joystick = JoyStickView(frame: joystickFrame)
        
        joystick?.monitor = { angle, displacement in
            self.angle = angle
            self.displacemet = displacement
        }
        
        view.addSubview(joystick!)
        
        joystick?.movable = false
        joystick?.alpha = 1.0
        joystick?.baseAlpha = 1.0 // let the background bleed thru the base
        
        joystick?.beginHandler = {
            
            self.joystickInUse = true
            self.startTime = Date().timeIntervalSinceReferenceDate
            self.stopTimer = false
            
        }
        
        joystick?.trackingHandler = {
            
        }
        
        joystick?.stopHandler = {
            
            
            self.joystickInUse = false
            self.stopTimer = false
            self.playerNode.removeAction(forKey: "repeatForever")
            let playerTexture = SKTexture(imageNamed: "Odessa-idle-frame1")
            self.playerNode.texture = playerTexture
            self.currentOdessaIdleSprite = 1
            //self.playerNode.physicsBody = SKPhysicsBody(texture: self.playerNode.texture! , size: CGSize(width: self.playerNode.size.width, height: self.playerNode.size.height))
            
            
        }
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
            location = t.location(in: cam)
            
           
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
                
               fingerIsTouching = true
                //////////////////////////////////////// FAZER O LONG TAP AQUI
                //print("block")
                let animateAction = SKAction.animate(with: movements.blockArray, timePerFrame: 0.1, resize: true, restore: false)
                let repeatAction = SKAction.repeat(animateAction, count: 1)
                self.playerNode.run(repeatAction, withKey: "repeatAction")
            }
            
            if (HUDNode.jumpButtonNode.frame.contains(location) ){
                
                print("jump")
                
                self.playerNode.run(movements.jumpAction, withKey: "repeatAction")
                
            }

        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: cam))
            
//            playerNode.removeAction(forKey: "repeatAction")
            velocityX = 0
//            let animateAction = SKAction.animate(with: movements.idleArray, timePerFrame: 0.2, resize: true, restore: false)
//            let repeatAction = SKAction.repeatForever(animateAction)
//            self.playerNode.run(repeatAction)
//            
//            fingerIsTouching = false
  
        }

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        fingerIsTouching = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
//        HUDNode.blockButtonNode.frame.contains(location)
        
        
//        if (fingerIsTouching == true){
//            
//            longAnimation()
//            fingerIsTouching = false
//            
//        }
        
        
        // Camera
        cam.position = playerNode.position
        
//         self.playerNode.position.x += velocityX
        
        // Game Over
        if (playerNode.position.y < -239){
            
            let nextScene = GameOverScene(size: self.scene!.size)
            nextScene.scaleMode = self.scaleMode
            nextScene.backgroundColor = UIColor.black
            self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 1.5))
        }
        
        
        // Current Sprite
        if (currentOdessaRunSprite == 9){
            currentOdessaRunSprite = 0
        }
        
        if (currentOdessaIdleSprite == 4){
            currentOdessaIdleSprite = 0
        }
        
        // Joystick
        if joystickInUse == true {
            
            // Movimentação
            if (self.angle >= 60 && self.angle <= 120){
                
                self.playerNode.position.x += displacemet*3
                let rightScale = SKAction.scaleX(to: 1, duration: 0)
                self.playerNode.run(rightScale)
                
                if dt > 0.1 {
                    dt = 0
                    self.startTime = Date().timeIntervalSinceReferenceDate
                    let playerTexture = SKTexture(imageNamed: "odessaRunframe" + String(currentOdessaRunSprite + 1))
                    playerNode.texture = playerTexture
                    currentOdessaRunSprite += 1
                }
                
                
            } else if (self.angle >= 240 && self.angle <= 300){
                
                self.playerNode.position.x -= displacemet*3
                let leftScale = SKAction.scaleX(to: -1, duration: 0)
                self.playerNode.run(leftScale)
                
                if dt > 0.1 {
                    dt = 0
                    self.startTime = Date().timeIntervalSinceReferenceDate
                    let playerTexture = SKTexture(imageNamed: "odessaRunframe" + String(currentOdessaRunSprite + 1))
                    playerNode.texture = playerTexture
                    currentOdessaRunSprite += 1
                }
                
            } else {
                
                if dt > 0.30 {
                    dt = 0
                    self.startTime = Date().timeIntervalSinceReferenceDate
                    let playerTexture = SKTexture(imageNamed: "Odessa-idle-frame" + String(currentOdessaIdleSprite + 1))
                    playerNode.texture = playerTexture
                    currentOdessaIdleSprite += 1
                }
                
            }
            
            // Contador para mudar os sprites
            endTime = Date().timeIntervalSinceReferenceDate
            dt = Double(endTime - startTime)
            
            
        }
        
        if joystickInUse == false {
            
            endTime = Date().timeIntervalSinceReferenceDate
            dt = Double(endTime - startTime)
            
            if dt > 0.30 {
                dt = 0
                self.startTime = Date().timeIntervalSinceReferenceDate
                let playerTexture = SKTexture(imageNamed: "Odessa-idle-frame" + String(currentOdessaIdleSprite + 1))
                playerNode.texture = playerTexture
                currentOdessaIdleSprite += 1
            }
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
    
   
    
//    func longAnimation(){
//        
//        let animateAction = SKAction.animate(with: movements.longBlockArray, timePerFrame: 0.1, resize: true, restore: false)
//        let repeatAction = SKAction.repeatForever(animateAction)
//        self.playerNode.run(repeatAction, withKey: "repeatAction")
//        
//    }
    
    
    
}


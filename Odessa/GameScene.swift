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

class GameScene: SKScene,  SKPhysicsContactDelegate {
    
    
    var modulesInitialPositions: [CGFloat] = []
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
    var enemyNode = SKSpriteNode(texture: SKTexture(imageNamed: "hoplita_walk-frame1"))
    
    var lancaNode = SKSpriteNode(texture: SKTexture(imageNamed: "lanca-odessa-attackframe1"))
    var hud = SKNode()
    var inimigosNode = [SKSpriteNode()]
    
    
    var mapa: Mapa?
    var HUDNode = HUD()
    var movements = Movimentacao()
    var parallax = ParallaxScene()
    
    
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
    
    // Time of last frame
    var lastFrameTime : TimeInterval = 0
    
    // Time since last frame
    var deltaTime : TimeInterval = 0
    
    
    
    var location = CGPoint(x: 0, y: 0)
    
    //Joystick
    var joystick: JoyStickView?
    var angle = CGFloat(0)
    var displacement = CGFloat(0)
    
    //Current Frame
    var currentOdessaRunSprite = 0
    var currentOdessaIdleSprite = 0
    
    //Joystick
    var joystickInUse = false
    
    //Timer da animação dos frames idle, run, jump da Odessa
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var dt = 0.00
    var stopTimer : Bool!
    
    //Boolean
    var fingerIsTouching:Bool = false
    var attack:Bool = false
    var block:Bool = false
    
    //Timer do Jump
    var jumpStartTime: TimeInterval = 0
    var jumpEndTime: TimeInterval = 0
    var jumpDt = 0.00
    var jump:Bool = false
    
    //Timer do LongBlock
    var longBlockStartTime: TimeInterval = 0
    var longBlockEndTime: TimeInterval = 0
    var longBlockDt = 0.00
    var longBlock:Bool = false
    
    var ultimo = CGFloat()
    var posicaoBandeira = CGFloat()
    
    
    
    let MaxHealth = 250
    var playerHP = 250
    var enemyHP = 100
    let HealthBarWidth: CGFloat = 250
    let HealthBarWE: CGFloat = 40
    let HealthBarHeight: CGFloat = 4
    let HealthBarHO: CGFloat = 7
    
    
    let enemyHealthBar = SKSpriteNode()
  

    var inimigol = 4
    
    var  pontos: Int = 0 {
        didSet{
            HUDNode.pontosLabel.text = "\(pontos)"
        }
    }
    
//    let moeda = SKSpriteNode(imageNamed: "moeda")
   
    
    override func sceneDidLoad() {
        
       

        // Mapa
        mapa = createMap()
        let floor = organizeMap()
        floor.physicsBody?.isDynamic = false
        addChild(floor)
        
        // Inicializa as animações
        movements.setMovements()
        movements.setAction(player: playerNode, velocity: velocityX)
        
        //Incializa Parallax
//        parallax.setParallax()
     
        // Player
        playerNode.size = CGSize(width: size.height/4, height: size.height/4)
        playerNode.position = CGPoint(x: 100, y: 400)
        
        // criar uma função pra pegar a textura atual da odessa e mudar o physics body conforme ela no update
        //playerNode.physicsBody = SKPhysicsBody(texture: playerNode.texture! , size: CGSize(width: playerNode.size.width, height: playerNode.size.height))
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 32.5, height: 60))
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.zPosition = 1
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = PhysicsCategory.odessa
        playerNode.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        addChild(self.playerNode)
        idleOdessa()
        
        //hoplita
       // enemyNode.setScale(0.34)
        
//        for index in 0...300 {
//            print("AAAAAAAAA")
        
//            var spriteEnemy = SKSpriteNode(texture: SKTexture(imageNamed: "hoplita_walk-frame1"))
            enemyNode.size = CGSize(width: size.height/4, height: size.height/4)
            enemyNode.position = CGPoint(x: 500, y: 500)
            enemyNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            enemyNode.physicsBody?.allowsRotation = false
            enemyNode.physicsBody?.usesPreciseCollisionDetection = true
          //  enemyNode.physicsBody?.affectedByGravity = false
            enemyNode.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            //  enemyNode.physicsBody?.contactTestBitMask = PhysicsCategory.odessa
        
         //   addChild(enemyNode)
        
//        }
        
        
        //Lança
        lancaNode.size = CGSize(width: 25/24*size.height/4, height: size.height/4)
        lancaNode.name = "lancaNode"
        
        // Background
        background = SKSpriteNode(texture: SKTexture(imageNamed: "fundo"))
        background.zPosition = -6
        background.setScale(0.5)
        
        // Set gestures into HUD buttons
        HUDNode.buttonConfiguration(screenSize: UIScreen.main.bounds.size, camera: cam)
        hud = HUDNode.getHUDNode()
        
        //hud.addChild(HUDNode.HUDNode)
        
        //addChild(hud)
        //view?.addSubview(hud.inputView!)
 
        ultimo = modulesInitialPositions.last!
        setFlag()
        
        
    }
    
    override func didMove(to view: SKView) {
        
//        setScore()
        updateHealthBar(node: HUDNode.playerHealthBar, withHealthPoints: MaxHealth)
        updateHealthBar(node: enemyHealthBar, withHealthPoints: enemyHP)
        
        physicsWorld.contactDelegate = self
        
       
       
//        moeda.position = CGPoint(x: 500 , y: 280)
//        moeda.setScale(0.8)
     
       
        
        
   
        // MARK: Camera
        let center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        
        //let center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        //cam.position = center
        //addChild(cam)
        
        camera = cam
        addChild(cam)
        cam.addChild(hud)
        cam.addChild(background)
      //  cam.addChild(parallax.frente)
       // cam.addChild(parallax.meio)
        
//        cam.addChild(playerHealthBar)
        cam.addChild(enemyHealthBar)
//        cam.addChild(moeda)
        cam.addChild(enemyNode)
    //    cam.addChild(pontosLabel)
        
        
        
     //   cam.addChild(ParallaxScene().parallaxNode)
     //   cam.addChild(ParallaxScene().parallaxNode)

        //cam.addChild(hud)
        
        // MARK: joystick
        let rect = view.frame
        let size = CGSize(width: 80.0, height: 80.0)
        let joystickFrame = CGRect(origin: CGPoint(x: 40.0, y: (rect.height - size.height - 25.0)), size: size)
        joystick = JoyStickView(frame: joystickFrame)
        
        joystick?.monitor = { angle, displacement in
            self.angle = angle
            self.displacement = displacement
        }
        
        view.addSubview(joystick!)
        
        joystick?.movable = false
        joystick?.alpha = 1.0
        joystick?.baseAlpha = 1.0 // let the background bleed thru the base
        
        joystick?.beginHandler = {
            
            self.joystickInUse = true
            self.startTime = Date().timeIntervalSinceReferenceDate
            self.stopTimer = false
            self.runOdessa()
            
        }
        
        joystick?.trackingHandler = {
            
            if (self.angle >= 60 && self.angle <= 120){
                
                let rightScale = SKAction.scaleX(to: 1, duration: 0)
                self.playerNode.run(rightScale)
                
            } else if (self.angle >= 240 && self.angle <= 300){
                
                let leftScale = SKAction.scaleX(to: -1, duration: 0)
                self.playerNode.run(leftScale)
                
            }
            
        }
        
        joystick?.stopHandler = {
            
            
            self.joystickInUse = false
            self.stopTimer = false
            self.playerNode.removeAction(forKey: "repeatForever")
            let playerTexture = SKTexture(imageNamed: "Odessa-idle-frame1")
            self.playerNode.texture = playerTexture
            self.currentOdessaIdleSprite = 1
            //self.playerNode.physicsBody = SKPhysicsBody(texture: self.playerNode.texture! , size: CGSize(width: self.playerNode.size.width, height: self.playerNode.size.height))
            self.playerNode.removeAction(forKey: "runOdessa")
            
            
        }
//
        
       
        
        
        
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
            
            if (HUDNode.attackButtonNode.frame.contains(location)) && attack == false && block == false {
                
                attack = true
                
                let animateAction = SKAction.animate(with: movements.attackArray, timePerFrame: 0.1, resize: false, restore: false)
                
                let animateLanca = SKAction.animate(with: self.movements.lancaAttack, timePerFrame: 0.1, resize: false, restore: false)
                
                
                let addLanca = SKAction.run({
                    
                    self.playerNode.addChild(self.lancaNode)
                    self.lancaNode.position = CGPoint(x: 20, y: 0)
                    self.lancaNode.zPosition = -1
                    
                    self.lancaNode.run(animateLanca)
                    
                })
                
                
                let end = SKAction.run({
                    
                    self.playerNode.removeAction(forKey: "attackAction")
                    self.attack = false
                    
                    for child in self.playerNode.children{
                        if child.name == "lancaNode"{
                            child.removeFromParent()
                        }
                    }
                    
                    
                })
                
                
                let group = SKAction.group([animateAction, addLanca])
                let sequence = SKAction.sequence([group,end])
                self.playerNode.run(sequence, withKey: "attackAction")
                
                
            }
            
            if (HUDNode.blockButtonNode.frame.contains(location)) && attack == false && block == false && longBlock == false {
                
                block = true
                fingerIsTouching = true
                
                let animateAction = SKAction.animate(with: movements.blockArray, timePerFrame: 0.20, resize: false, restore: false)
                
                let animateLanca = SKAction.animate(with: self.movements.lancaBlock, timePerFrame: 0.20, resize: false, restore: false)
                
                let addLanca = SKAction.run({
                    
                    self.playerNode.addChild(self.lancaNode)
                    self.lancaNode.position = CGPoint(x: 20, y: 0)
                    self.lancaNode.zPosition = -1
                    
                    self.lancaNode.run(animateLanca)
                    
                })
                
                let end = SKAction.run({
                    
                    self.playerNode.removeAction(forKey: "blockAction")
                    self.block = false
                    
                    for child in self.playerNode.children{
                        if child.name == "lancaNode"{
                            child.removeFromParent()
                        }
                    }
                    
                })
                
                let group = SKAction.group([animateAction, addLanca])
                let sequence = SKAction.sequence([group, end])
                
                
                self.playerNode.run(sequence, withKey: "blockAction")
                self.longBlockStartTime = Date().timeIntervalSinceReferenceDate
                
                
            }
            
            if (HUDNode.jumpButtonNode.frame.contains(location) ) && jump == false{
                
                
                if attack == true || block == true || longBlock == true{
                    
                    self.playerNode.removeAction(forKey: "attackAction")
                    self.playerNode.removeAction(forKey: "blockAction")
                    
                    
                    for child in self.playerNode.children{
                        if child.name == "lancaNode"{
                            child.removeFromParent()
                        }
                    }
                    
                    attack = false
                    block = false
                    
                }
                
                //                self.playerNode.run(movements.jumpAction, withKey: "repeatAction")
                //                self.jumpStartTime = Date().timeIntervalSinceReferenceDate
                
                jump = true
                
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
                
                let jumpUp = SKAction.moveBy(x: 0, y: 240, duration: 0.3)
                let fallBack = SKAction.moveBy(x: 0, y: 0, duration: 0.3)
                
                let impulso = SKAction.animate(with: impulsoArray, timePerFrame: 0.1)
                let puloCima = SKAction.animate(with: puloCimaArray, timePerFrame: 0.05)
                let puloBaixo = SKAction.animate(with: puloBaixoArray, timePerFrame: 0.10)
                let group = SKAction.group([puloBaixo, fallBack])
                
                let endMoviment = SKAction.run({
                    
                    self.jump = false
                    self.playerNode.removeAction(forKey: "jumpAction")
                    
                    if self.joystickInUse == true {
                        self.runOdessa()
                    }
                    
                })
                
                let jumpAction = SKAction.sequence([impulso,puloCima, jumpUp, group, endMoviment])
                
                //                self.playerNode.removeAction(forKey: "runOdessa")
                self.playerNode.run(jumpAction, withKey: "jumpAction")
                
            }
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            self.touchUp(atPoint: t.location(in: cam))
            
            velocityX = 0
            
            fingerIsTouching = false
            
            if (HUDNode.blockButtonNode.frame.contains(location)) && longBlock == true{
                
                for child in self.playerNode.children{
                    if child.name == "lancaNode"{
                        child.removeFromParent()
                    }
                }
                
                self.block = false
                self.longBlock = false
                self.playerNode.removeAction(forKey: "longBlock")
                self.playerNode.removeAction(forKey: "blockAction")
                
                
            }
            
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            self.touchUp(atPoint: t.location(in: cam))
            
            velocityX = 0
            
            fingerIsTouching = false
            
            if (HUDNode.blockButtonNode.frame.contains(location)) && longBlock == true{
                
                for child in self.playerNode.children{
                    if child.name == "lancaNode"{
                        child.removeFromParent()
                    }
                }
                
                self.block = false
                self.longBlock = false
                self.playerNode.removeAction(forKey: "longBlock")
                self.playerNode.removeAction(forKey: "blockAction")
                
                
            }
            
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
   
        if (playerNode.position.x > 6862 ){

            let nextScene = VictoryScene(size: self.scene!.size)
            nextScene.scaleMode = self.scaleMode
            nextScene.backgroundColor = UIColor.black
            joystick?.removeFromSuperview()
            self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 0.5))

        }
        
        enemyHealthBar.position = CGPoint(
            x: enemyNode.position.x,
            y: enemyNode.position.y + enemyNode.size.height / 2
        )
        
        
        
        // First, update the delta time values:
        
        // If we don't have a last frame time value, this is the first frame,
        // so delta time will be zero.
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        // Update delta time
        deltaTime = currentTime - lastFrameTime
        
        // Set last frame time to current time
        lastFrameTime = currentTime
        
        
        self.moveSprite(sprite: parallax.frente, nextSprite: parallax.frenteNext, speed: 10.0)
        self.moveSprite(sprite: parallax.meio, nextSprite: parallax.frenteNext, speed: 5.0)
        
        
        
    
//        HUDNode.blockButtonNode.frame.contains(location)
        
        if (self.angle >= 60 && self.angle <= 120) && joystickInUse == true && longBlock == false {
            
            self.playerNode.position.x += self.displacement*3
            
        } else if (self.angle >= 240 && self.angle <= 300) && joystickInUse == true && longBlock == false{
            
            self.playerNode.position.x -= self.displacement*3
            
        }
        
        
        // Camera
       // cam.position = playerNode.position
        cam.position = CGPoint(x: playerNode.position.x, y: 120)
        
        //self.playerNode.position.x += velocityX
        
        // Game Over
        if (playerNode.position.y < -239){
            
            let nextScene = GameOverScene(size: self.scene!.size)
            // let nextScene = VictoryScene(size: self.size)
            nextScene.scaleMode = self.scaleMode
            nextScene.backgroundColor = UIColor.black
            joystick?.removeFromSuperview()
            self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 1.5))
        }
        
        
        //        // Current Sprite
        //        if (currentOdessaRunSprite == 9){
        //            currentOdessaRunSprite = 0
        //        }
        //
        //        if (currentOdessaIdleSprite == 4){
        //            currentOdessaIdleSprite = 0
        //        }
        //
        //        // Joystick
        //        if joystickInUse == true {
        //
        //            // Movimentação
        //            if (self.angle >= 60 && self.angle <= 120){
        //
        //                if (longBlock == false) {
        //                self.playerNode.position.x += displacement*3
        //                }
        //
        //                let rightScale = SKAction.scaleX(to: 1, duration: 0)
        //                self.playerNode.run(rightScale)
        //
        //                if dt > 0.1 {
        //                    dt = 0
        //                    self.startTime = Date().timeIntervalSinceReferenceDate
        //                    let playerTexture = SKTexture(imageNamed: "odessaRunframe" + String(currentOdessaRunSprite + 1))
        //                    playerNode.texture = playerTexture
        //                    currentOdessaRunSprite += 1
        //                }
        //
        //
        //            } else if (self.angle >= 240 && self.angle <= 300){
        //
        //                if (longBlock == false) {
        //                self.playerNode.position.x -= displacement*3
        //                }
        //
        //                let leftScale = SKAction.scaleX(to: -1, duration: 0)
        //                self.playerNode.run(leftScale)
        //
        //                if dt > 0.1 {
        //                    dt = 0
        //                    self.startTime = Date().timeIntervalSinceReferenceDate
        //                    let playerTexture = SKTexture(imageNamed: "odessaRunframe" + String(currentOdessaRunSprite + 1))
        //                    playerNode.texture = playerTexture
        //                    currentOdessaRunSprite += 1
        //                }
        //
        //            } else {
        //
        //                if dt > 0.30 && longBlock == false{
        //                    dt = 0
        //                    self.startTime = Date().timeIntervalSinceReferenceDate
        //                    let playerTexture = SKTexture(imageNamed: "Odessa-idle-frame" + String(currentOdessaIdleSprite + 1))
        //                    playerNode.texture = playerTexture
        //                    currentOdessaIdleSprite += 1
        //                }
        //
        //            }
        //
        //            // Contador para mudar os sprites
        //            endTime = Date().timeIntervalSinceReferenceDate
        //            dt = Double(endTime - startTime)
        //
        //
        //        }
        //
        //        if joystickInUse == false {
        //
        //            endTime = Date().timeIntervalSinceReferenceDate
        //            dt = Double(endTime - startTime)
        //
        //            if dt > 0.30 && longBlock == false{
        //                dt = 0
        //                self.startTime = Date().timeIntervalSinceReferenceDate
        //                let playerTexture = SKTexture(imageNamed: "Odessa-idle-frame" + String(currentOdessaIdleSprite + 1))
        //                playerNode.texture = playerTexture
        //                currentOdessaIdleSprite += 1
        //            }
        //        }
        //
        //        if jump == true {
        //            jumpEndTime = Date().timeIntervalSinceReferenceDate
        //            jumpDt = Double(jumpEndTime - jumpStartTime)
        //
        //            if jumpDt > 0.845 {
        //                jump = false
        //            }
        //
        //        }
        
        
        if (fingerIsTouching == true) && (longBlock == false){
            
            longBlockEndTime = Date().timeIntervalSinceReferenceDate
            longBlockDt = Double(longBlockEndTime - longBlockStartTime)
            
            if longBlockDt > 0.6 {
                odessaLongBlockAnimation()
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
            
            // aqui
            modulesInitialPositions.append(floor.calculateAccumulatedFrame().size.width - floorModule.size.width)
      //      print("\(modulesInitialPositions)")
            
            
            
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
    
    
    
    //    func longBlockAnimation(){
    //
    //        longBlock = true
    //
    //        let animateOdessa = SKAction.animate(with: movements.longBlockArray, timePerFrame: 0.10, resize: false, restore: false)
    //
    //        let animateLanca = SKAction.animate(with: self.movements.lancaLongBlock, timePerFrame: 0.10, resize: false, restore: false)
    //
    //        let repeatOdessa = SKAction.repeatForever(animateOdessa)
    //        let repeatLanca = SKAction.repeatForever(animateLanca)
    //
    //        let addLanca = SKAction.run({
    //
    //            self.playerNode.addChild(self.lancaNode)
    //            self.lancaNode.position = CGPoint(x: 20, y: 0)
    //            self.lancaNode.zPosition = -1
    //
    //            self.lancaNode.run(repeatLanca)
    //
    //        })
    //
    //
    //        let group = SKAction.group([repeatOdessa, addLanca])
    //
    //        self.playerNode.run(group, withKey: "repeatAction")
    //
    //
    //    }
    
    // Odessa
    
    func odessaLongBlockAnimation(){
        
        longBlock = true
        
        var longBlockArray = [SKTexture]() //Odessa long Block
        var lancaLongBlock = [SKTexture]() //Lança long Block
        
        for i in 1...3 {
            longBlockArray.append(SKTexture(imageNamed: "Odessa-block-hold-frame\(i)"))
        }
        
        for i in 1...3 {
            lancaLongBlock.append(SKTexture(imageNamed: "Lanca-Odessa-block-hold-frame\(i)"))
        }
        
        let animateOdessa = SKAction.animate(with: longBlockArray, timePerFrame: 0.10, resize: false, restore: false)
        
        let animateLanca = SKAction.animate(with: lancaLongBlock, timePerFrame: 0.10, resize: false, restore: false)
        
        let repeatOdessa = SKAction.repeatForever(animateOdessa)
        let repeatLanca = SKAction.repeatForever(animateLanca)
        
        let addLanca = SKAction.run({
            
            self.playerNode.addChild(self.lancaNode)
            self.lancaNode.position = CGPoint(x: 20, y: 0)
            self.lancaNode.zPosition = -1
            
            self.lancaNode.run(repeatLanca)
            
        })
        let group = SKAction.group([repeatOdessa, addLanca])
        self.playerNode.run(group, withKey: "longBlock")
    }
    
    func moveSprite(sprite : SKSpriteNode, nextSprite : SKSpriteNode, speed : Float) -> Void {
        var newPosition = CGPoint(x: 50, y: 0)
        
        // For both the sprite and its duplicate:
        for spriteToMove in [sprite, nextSprite] {
            
            // Shift the sprite leftward based on the speed
            newPosition = spriteToMove.position
            
            newPosition.x -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            // If this sprite is now offscreen (i.e., its rightmost edge is
            // farther left than the scene's leftmost edge):
            if (spriteToMove.frame.maxX < self.frame.minX) {
                
                // Shift it over so that it's now to the immediate right
                // of the other sprite.
                // This means that the two sprites are effectively
                // leap-frogging each other as they both move.
                spriteToMove.position = CGPoint(x: spriteToMove.position.x - spriteToMove.size.width * 2, y: spriteToMove.position.y)
            }
            
        }
    }
        
        
        func idleOdessa(){
            
            var idleArray = [SKTexture]()
            
            for i in 1...4 {
                idleArray.append(SKTexture(imageNamed: "Odessa-idle-frame\(i)"))
            }
        
        
        let animateOdessa = SKAction.animate(with: idleArray, timePerFrame: 0.15, resize: false, restore: false)
        
        let repeatForever = SKAction.repeatForever(animateOdessa)
        
        
        self.playerNode.run(repeatForever, withKey: "idleOdessa")
            
        }
        
        
    
    
    func runOdessa(){
        
        var runArray = [SKTexture]()
        
        for i in 1...9 {
            runArray.append(SKTexture(imageNamed: "odessaRunframe\(i)"))
        }
        
        let animateOdessa = SKAction.animate(with: runArray, timePerFrame: 0.13, resize: false, restore: false)
        
        let repeatForever = SKAction.repeatForever(animateOdessa)
        
        
        self.playerNode.run(repeatForever, withKey: "runOdessa")
        
        
    }
    
    func setFlag(){
        
        var bandeirao = SKSpriteNode()
        var bandeiraGrande = [SKTexture]()
        for i in 1...6 {
            bandeiraGrande.append(SKTexture(imageNamed:("Bandeira1frame\(i)")))
        }
        bandeirao = SKSpriteNode(texture: bandeiraGrande[0])
        let balancarAction = SKAction.animate(with: bandeiraGrande, timePerFrame: 0.26, resize: true, restore: false)
        let repeatBandeira = SKAction.repeatForever(balancarAction)
        
        
        
        
        bandeirao.run(repeatBandeira, withKey: "repeatBandeira")
        bandeirao.position = CGPoint(x: 6862, y: 150)
        bandeirao.zPosition = -2
        bandeirao.setScale(0.35)
        addChild(bandeirao)
        
        posicaoBandeira = bandeirao.position.x
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.odessa != 0)) {
            
            odessaAttackedEnemy(enemy: firstBody.node as! SKSpriteNode, odessa: secondBody.node as! SKSpriteNode)
        }
        
        
    }
    
    func odessaAttackedEnemy(enemy:SKSpriteNode, odessa:SKSpriteNode) {    // aconteceu colisão entre odessa einimigo
        
        print("aaaaa")
        
        enemyHP = max(0, enemyHP - 25)
        updateHealthBar(node: enemyHealthBar, withHealthPoints: enemyHP)

        //  updateHealthBar(node: playerHealthBar, withHealthPoints: playerHP)

        print("atacou inimigo")

        inimigol -= 1

        if (inimigol == 0){


            print("inimigo morreu")

            enemyNode.removeFromParent()

            pontos += 100

            //  inimigoLabel.removeFromParent()
            enemyHealthBar.removeFromParent()
        }
        
    }

    
    func updateHealthBar(node: SKSpriteNode, withHealthPoints hp: Int) {
        
        
        if (node == enemyHealthBar){
            
            let barSize = CGSize(width: HealthBarWE, height: HealthBarHeight);
            
            let fillColor = UIColor(red: 113.0/255, green: 202.0/255, blue: 53.0/255, alpha:1)
            let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
            
            // create drawing context
            UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
            let context = UIGraphicsGetCurrentContext()
            
            // draw the outline for the health bar
            borderColor.setStroke()
            let borderRect = CGRect(origin: CGPoint(x:0, y:0), size: barSize)
            context!.stroke(borderRect, width: 1)
            
            // draw the health bar with a colored rectangle
            fillColor.setFill()
            let barWidth = (barSize.width - 1) * CGFloat(hp) / CGFloat(100)
            let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
            context!.fill(barRect)
            
            // extract image
            let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // set sprite texture and size
            node.texture = SKTexture(image: spriteImage!)
            node.size = barSize
        }
            
        else {
            
            let barSize = CGSize(width: HealthBarWidth, height: HealthBarHO);
            let fillColor = UIColor(red: 197.0/255, green: 76.0/255, blue: 91.0/255, alpha:1)
            // create drawing context
            UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
            let context = UIGraphicsGetCurrentContext()
            
            // draw the health bar with a colored rectangle
            fillColor.setFill()
            let barWidth = (barSize.width - 1) * CGFloat(hp) / CGFloat(MaxHealth)
            let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
            context!.fill(barRect)
            
            // extract image
            let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // set sprite texture and size
            node.texture = SKTexture(image: spriteImage!)
            node.size = barSize
            
        }
    }

    public struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let enemy   : UInt32 = 0b1       // 1
        static let odessa: UInt32 = 0b10      // 2
        static let chao    : UInt32 = 3
    }
    
    

    
    
}



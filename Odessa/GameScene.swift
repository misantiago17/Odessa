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
    
    
    
    var spriteArray = [SKTexture]() //Odessa Run
    var attackArray = [SKTexture]() //Odessa Attack
    var blockArray = [SKTexture]() //Odessa Block
    var longBlockArray = [SKTexture]() //Odessa long Block
    var idleArray = [SKTexture]()
    var impulsoArray = [SKTexture]()
    var puloCimaArray = [SKTexture]()
    var puloBaixoArray = [SKTexture]()
    var aterrissagemArray = [SKTexture]()
    
    let barras = SKSpriteNode(imageNamed: "Barras")
    

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
    
    // Botões de ação
    var attackButton = UIButton() // botão de ataque
    var blockButton = UIButton() // botão de block
    var jumpButton = UIButton() //botão pulo
    
    // Botões de movimento
//    var direitaButton = UIButton()
//    var esquerdaButton = UIButton()
    
    var jumpAction = SKAction()

    //MARK: SETAS
    let direita = SKSpriteNode(imageNamed: "dir")
    let esquerda = SKSpriteNode(imageNamed: "esq")
   
    //movimento
    var velocityX:CGFloat = 0.0
    var velocityY:CGFloat = 0.0
    
    let bg = SKSpriteNode(texture: SKTexture(imageNamed: "fundo"))
    
    override func sceneDidLoad() {
        
        //MARK: Odessa Attack
        for i in 1...7 {
            attackArray.append(SKTexture(imageNamed: "odessa-attackframe\(i)"))
        }
   
        //MARK: Odessa Block
        for i in 1...2 {
            blockArray.append(SKTexture(imageNamed: "Odessa-block-frame\(i)"))
        }
        
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
        
 
        
       
        
        
        
        
        // Mapa
        mapa = createMap()
        let floor = organizeMap()
        floor.physicsBody?.isDynamic = false
        addChild(floor)
        
        // Player
        playerNode = SKSpriteNode(texture:spriteArray[0])
        playerNode.setScale(0.34) //0.68
        playerNode.position = CGPoint(x: 100, y: 400)
       playerNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) //  ver isso
        
        //playerNode.physicsBody = SKPhysicsBody(texture: spriteArray[0], size: spriteArray[0].size())
        
        playerNode.zPosition = 1
        playerNode.physicsBody?.allowsRotation = false
        addChild(self.playerNode)
        
        
      
        let jumpUp = SKAction.moveBy(x: playerNode.position.x, y: 200, duration: 0.3)
        let fallBack = SKAction.moveBy(x: 0, y: 0, duration: 0.3)
        var jumpSequence = SKAction()
        
        
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
            floorModule.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floorModule.frame.width, height: floorModule.frame.height))
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


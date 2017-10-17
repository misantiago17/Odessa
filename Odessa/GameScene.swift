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
    
    
    var spriteArray = [SKTexture]() //Odessa Run
    var attackArray = [SKTexture]() //Odessa Attack
    var blockArray = [SKTexture]() //Odessa Block
    var longBlockArray = [SKTexture]() //Odessa long Block
    var idleArray = [SKTexture]()
    var impulsoArray = [SKTexture]()
    var puloCimaArray = [SKTexture]()
    var puloBaixoArray = [SKTexture]()
    var aterrissagemArray = [SKTexture]()
    
    
    

    //Oraganização: precisa de coisa pra caralho
    
    //Public
    // - Fundo animado
    var player: Player = Player(nome: "Odessa", vida: 100, velocidade: 100.0, defesa: 30, numVida: 3, ataqueEspecial: 75)
    var playerNode = SKSpriteNode()
    
    
    
    // - Inimigos
    var mapa: Mapa?
    // HUD:
    // - Vida
    // - Especial
    // - BtnDeAtaque1
    // - BtnDeAtaque2
    // - Joystick
    // - Moedas
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private let cam = SKCameraNode()
    // Criar uma função responsavel por unir cada bloco de chão com sua largura sem falhas e retorna um único sprite com todo o chão do nível
    
    // Botões de ação
    var attackButton = UIButton() // botão de ataque
    var blockButton = UIButton() // botão de block
    var jumpButton = UIButton() //botão pulo
    
    // Botões de movimento
    var direitaButton = UIButton()
    var esquerdaButton = UIButton()
    
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
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
        playerNode.zPosition = 1
        playerNode.physicsBody?.allowsRotation = false
        addChild(self.playerNode)
        
        
      
        let jumpUp = SKAction.moveBy(x: playerNode.position.x, y: 200, duration: 0.3)
        let fallBack = SKAction.moveBy(x: 0, y: 0, duration: 0.3)
        var jumpSequence = SKAction()
        
        
        //MARK: Animations config
        
        let impulso =  SKAction.animate(with: impulsoArray, timePerFrame: 0.1, resize: true, restore: false)
        let puloCima = SKAction.animate(with: puloCimaArray, timePerFrame: 0.05, resize: true, restore: false)
        let puloBaixo = SKAction.animate(with: puloBaixoArray, timePerFrame: 0.19, resize: true, restore: false)
        //        let aterrisagem =  SKAction.animate(with: aterrissagemArray, timePerFrame: 0.3, resize: true, restore: false)
        
        jumpSequence = SKAction.sequence([impulso,puloCima, jumpUp ,puloBaixo, fallBack])
        jumpAction = jumpSequence
        
        
        // Camera
        self.camera = cam
       
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        

    }
    
     override func didMove(to view: SKView) {
        
        //MARK: Gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameScene.Tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(GameScene.Long))
        tapGesture.numberOfTapsRequired = 1
        let attackGesture = UITapGestureRecognizer(target: self, action: #selector(GameScene.Attack(_:)))
        attackGesture.numberOfTapsRequired = 1
        let jumpGesture = UITapGestureRecognizer(target: self, action: #selector(GameScene.Jump(_: )))
        let direitaGesture = UILongPressGestureRecognizer(target: self, action: #selector(GameScene.Direita(_: )))
        let esquerdaGesture = UILongPressGestureRecognizer(target: self, action: #selector(GameScene.Esquerda(_: )))
        
        
        
        blockButton.addGestureRecognizer(tapGesture)
        blockButton.addGestureRecognizer(longGesture)
        attackButton.addGestureRecognizer(attackGesture)
        jumpButton.addGestureRecognizer(jumpGesture)
        
        
        
        // Fundo
        
        bg.zPosition = -2
        bg.setScale(0.5)
        bg.position = CGPoint(x:(self.view?.frame.maxX)! , y: (self.view?.frame.maxY)!)
        
        addChild(bg)
        
      // CGPoint(x: view.frame.size.width/2 + 145  , y: view.frame.size.height/2 + 105)
        
        //Seta
//        self.direita.position =  CGPoint(x: view.frame.size.width/2 + 145  , y: view.frame.size.height/2 + 1) //100
//        self.esquerda.position =  CGPoint(x: view.frame.size.width/2 + 145  , y: view.frame.size.height/2 + 1) //100
//        direita.zPosition = 2
//        esquerda.zPosition = 2
//        direita.setScale(1.6)
//        esquerda.setScale(1.6)
//        self.addChild(direita)
//        self.addChild(esquerda)
        
        //MARK: config botao de ataque
        
        attackButton = UIButton(frame: CGRect(x: 0, y:0, width: 95, height: 95))
        attackButton.backgroundColor = UIColor.clear
        attackButton.center =  CGPoint(x: view.frame.size.width/2 + 145  , y: view.frame.size.height/2 + 105)
        attackButton.addGestureRecognizer(attackGesture)
        self.view?.addSubview(attackButton)
        let aimage = UIImage(named: "aButton") as UIImage!
        _  = UIButton(type: .custom)
        attackButton.setImage(aimage, for: .normal)
        
        //MARK: config botao de block
        
        blockButton = UIButton(frame: CGRect(x: 0, y:0, width: 50, height: 50))
        blockButton.backgroundColor = UIColor.clear
        blockButton.center =  CGPoint(x: view.frame.size.width/2 + 230  , y: view.frame.size.height/2 + 60)
        blockButton.addGestureRecognizer(tapGesture)
        blockButton.addGestureRecognizer(longGesture)
        blockButton.setImage(UIImage(named: "sButton"), for: .normal)
        
        self.view?.addSubview(blockButton)
        
        //MARK: config jump button
        
        jumpButton = UIButton(frame: CGRect(x: 0, y:0, width: 60, height: 60))
        jumpButton.backgroundColor = UIColor.clear
        jumpButton.center =  CGPoint(x: view.frame.size.width/2 + 230  , y: view.frame.size.height/2 + 120)
        jumpButton.addGestureRecognizer(jumpGesture)
        jumpButton.setImage(UIImage(named: "jumpButton"), for: .normal)
        
        self.view?.addSubview(jumpButton)
        

        
        direitaButton = UIButton(frame: CGRect(x: 0, y:0, width: 60, height: 60))
        direitaButton.backgroundColor = UIColor.clear
        direitaButton.center =  CGPoint(x: view.frame.size.width/2 - 140  , y: view.frame.size.height/2 + 110)
        direitaButton.addGestureRecognizer(direitaGesture)
        direitaButton.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        direitaButton.setImage(UIImage(named: "dir"), for: .normal)
        
        self.view?.addSubview(direitaButton)
        
        esquerdaButton = UIButton(frame: CGRect(x: 0, y:0, width: 60, height: 60))
        esquerdaButton.backgroundColor = UIColor.clear
        esquerdaButton.center =  CGPoint(x: view.frame.size.width/2 - 210  , y: view.frame.size.height/2 + 110)
        esquerdaButton.addGestureRecognizer(esquerdaGesture)
        esquerdaButton.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        esquerdaButton.setImage(UIImage(named: "esq"), for: .normal)
        
        self.view?.addSubview(esquerdaButton)
        
     
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
//        for t in touches { self.touchDown(atPoint: t.location(in: self))
//
//              let location = t.location(in: self)
//
//            if (direita.frame.contains(location)){
//
//
//                let animateAction = SKAction.animate(with: self.spriteArray, timePerFrame: 0.1, resize: true, restore: false)
//                let repeatAction = SKAction.repeatForever(animateAction)
//
//
//                let rightScale = SKAction.scaleX(to: 0.35, duration: 0)
//                let group = SKAction.group([repeatAction, rightScale])
//
//                self.playerNode.run(group, withKey: "repeatAction")
//
//                velocityX = (direita.position.x - direita.position.x + 50)/20
//
//                self.playerNode.position.x += velocityX
//
//
//            }
//
//            else if (esquerda.frame.contains(location)){
//
//                print(velocityX)
//
//
//                let animateAction = SKAction.animate(with: self.spriteArray, timePerFrame: 0.1, resize: true, restore: false)
//                let repeatAction = SKAction.repeatForever(animateAction)
//
//                let leftScale = SKAction.scaleX(to: -0.35, duration: 0)
//                let group = SKAction.group([repeatAction, leftScale])
//
//                self.playerNode.run(group, withKey: "repeatAction")
//
//                velocityX = (direita.position.x - direita.position.x - 50)/20
//
//                self.playerNode.position.x += velocityX
//
//            }
//
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self))
            
            playerNode.removeAction(forKey: "repeatAction")
            velocityX = 0
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Camera
        
        cam.position = playerNode.position
        
        //Posicao player
        self.playerNode.position.x += velocityX
        self.playerNode.position.y += velocityY
      
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        self.lastUpdateTime = currentTime
    }
    
    // -- Cria Mapa
    
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
    
    // -- Arruma os sprites do mapa
    
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
    
    // Achar uma forma de encontrar o CGpoint inicial do node (0.0,1.0) e final (1.0,1.0) e colocar a altura do próx node equivalente a altura do node anterior
    // Achar o ponto inicial por matematica, pegando a posição.x - metade do tamanho.x e posição.y - metado do tamnaho.y 
    
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
    
    
    //MARK: Gesture func
    
    func Attack(_ sender: UIGestureRecognizer) {
        
        let animateAction = SKAction.animate(with: self.attackArray, timePerFrame: 0.1, resize: true, restore: false)
        let repeatAction = SKAction.repeat(animateAction, count: 1)
        self.playerNode.run(repeatAction, withKey: "repeatAction")
        
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
        let animateAction = SKAction.animate(with: self.blockArray, timePerFrame: 0.1, resize: true, restore: false)
        let repeatAction = SKAction.repeat(animateAction, count: 1)
        self.playerNode.run(repeatAction, withKey: "repeatAction")

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
        print("long")
        let animateAction = SKAction.animate(with: self.longBlockArray, timePerFrame: 0.1, resize: true, restore: false)
        let repeatAction = SKAction.repeatForever(animateAction)
        self.playerNode.run(repeatAction, withKey: "repeatAction")

        if sender.state == .ended {

            print("UIGestureRecognizerStateEnded")
            playerNode.removeAction(forKey: "repeatAction")

            let animateAction = SKAction.animate(with: self.idleArray, timePerFrame: 0.3, resize: true, restore: false)
            let repeatAction = SKAction.repeatForever(animateAction)
            self.playerNode.run(repeatAction)
        }
 
    }
    
    
    func Jump(_ sender: UIGestureRecognizer) {
        
        print("jump")
        
        
        let repeatAction = SKAction.repeat(jumpAction, count: 1)
        self.playerNode.run(repeatAction, withKey: "repeatAction")
        
        
        //        let animateAction = SKAction.animate(with: self.blockArray, timePerFrame: 0.1, resize: true, restore: false)
        //        let repeatAction = SKAction.repeat(animateAction, count: 1)
        //        self.player.run(repeatAction, withKey: "repeatAction")
        //
        
        
        
    }
   
    func Direita(_ sender: UIGestureRecognizer) {
        
        print("Direita")
        
         playerNode.removeAction(forKey: "repeatAction")
        
        let animateAction = SKAction.animate(with: self.spriteArray, timePerFrame: 0.1, resize: true, restore: false)
        let repeatAction = SKAction.repeatForever(animateAction)
        
        
        let rightScale = SKAction.scaleX(to: 0.35, duration: 0)
        let group = SKAction.group([repeatAction, rightScale])
        
        self.playerNode.run(group, withKey: "repeatAction")
        
        velocityX = (playerNode.position.x - playerNode.position.x + 50)/20
        
        self.playerNode.position.x += velocityX
        
        if sender.state == .ended {

            
            playerNode.removeAction(forKey: "repeatAction")
            velocityX = 0
            
            
            let animateAction = SKAction.animate(with: self.idleArray, timePerFrame: 0.3, resize: true, restore: false)
            let repeatAction = SKAction.repeatForever(animateAction)
            self.playerNode.run(repeatAction)
        


        }
        
        
        
    }
    
    func Esquerda(_ sender: UIGestureRecognizer) {
        
        print("Esquerda")
        
        playerNode.removeAction(forKey: "repeatAction")
        let animateAction = SKAction.animate(with: self.spriteArray, timePerFrame: 0.1, resize: true, restore: false)
        let repeatAction = SKAction.repeatForever(animateAction)
        
        let leftScale = SKAction.scaleX(to: -0.35, duration: 0)
        let group = SKAction.group([repeatAction, leftScale])
        
        self.playerNode.run(group, withKey: "repeatAction")
        
        velocityX = (playerNode.position.x - playerNode.position.x - 50)/20
        
        self.playerNode.position.x += velocityX
        
        if sender.state == .ended {

            
            playerNode.removeAction(forKey: "repeatAction")
            velocityX = 0

            playerNode.removeAction(forKey: "repeatAction")
            
            let animateAction = SKAction.animate(with: self.idleArray, timePerFrame: 0.3, resize: true, restore: false)
            let repeatAction = SKAction.repeatForever(animateAction)
            self.playerNode.run(repeatAction)
        

        }
        
    }
    
    
    
    
    
}

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
    
     var spriteArray = [SKTexture]() //Odessa Run

    //Oraganização: precisa de coisa pra caralho
    
    //Public
    // - Fundo animado
    var player: Player = Player(nome: "Odessa", vida: 100, velocidade: 100.0, defesa: 30, numVida: 3, ataqueEspecial: 75)
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
    
    // Criar uma função responsavel por unir cada bloco de chão com sua largura sem falhas e retorna um único sprite com todo o chão do nível
    
    var playerNode = SKSpriteNode()
    
    //MARK: SETAS
    let direita = SKSpriteNode(imageNamed: "dir")
    let esquerda = SKSpriteNode(imageNamed: "esq")
   
    //movimento
    var velocityX:CGFloat = 0.0
    var velocityY:CGFloat = 0.0
    
    
    
    override func sceneDidLoad() {
        
        
        
        self.direita.position = CGPoint(x: 150, y: 70) //100
        self.esquerda.position = CGPoint(x: 50, y: 70) //100
        direita.setScale(1.6)
        esquerda.setScale(1.6)
        self.addChild(direita)
        self.addChild(esquerda)
        
        // MARK: Odessa Run
        for i in 1...9 {
            spriteArray.append(SKTexture(imageNamed: "odessaRun\(i)"))
        }
        
        // Mapa
        mapa = createMap()
        let floor = organizeMap()
        addChild(floor)
        
        // Player
        playerNode = SKSpriteNode(texture:spriteArray[0])
        playerNode.setScale(0.34) //0.68
        playerNode.position = CGPoint(x: 100, y: 400)
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
        playerNode.zPosition = 1
        addChild(self.playerNode)
        
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
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
        
        for t in touches { self.touchDown(atPoint: t.location(in: self))
            
              let location = t.location(in: self)
            
            if (direita.frame.contains(location)){
                
                
                let animateAction = SKAction.animate(with: self.spriteArray, timePerFrame: 0.1, resize: true, restore: false)
                let repeatAction = SKAction.repeatForever(animateAction)
                
                
                let rightScale = SKAction.scaleX(to: 0.35, duration: 0)
                let group = SKAction.group([repeatAction, rightScale])
                
                self.playerNode.run(group, withKey: "repeatAction")
                
                velocityX = (direita.position.x - direita.position.x + 50)/20
                
                self.playerNode.position.x += velocityX
                
                
            }
            
            else if (esquerda.frame.contains(location)){
                
                print(velocityX)
                
                
                let animateAction = SKAction.animate(with: self.spriteArray, timePerFrame: 0.1, resize: true, restore: false)
                let repeatAction = SKAction.repeatForever(animateAction)
                
                let leftScale = SKAction.scaleX(to: -0.35, duration: 0)
                let group = SKAction.group([repeatAction, leftScale])
                
                self.playerNode.run(group, withKey: "repeatAction")
                
                velocityX = (direita.position.x - direita.position.x - 50)/20
                
                self.playerNode.position.x += velocityX
                
            }
            
            
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
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
            floorModule.physicsBody = SKPhysicsBody(texture: floorModule.texture!, size: (floorModule.texture?.size())!)
            floorModule.physicsBody?.affectedByGravity = false
            
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
}

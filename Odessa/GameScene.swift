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
import CoreData

class GameScene: SKScene,  SKPhysicsContactDelegate {
    
    //Public
    var background = SKSpriteNode()
    var player: Player = Player(nome: "Odessa", vida: 100, velocidade: 100.0, defesa: 30, numVida: 3, ataqueEspecial: 75)
    
    var playerNode = SKSpriteNode(texture: SKTextureAtlas(named: "Idle").textureNamed("Odessa-idle-frame1"))
    var enemyNode = SKSpriteNode(texture: SKTextureAtlas(named: "Inimigos").textureNamed("enemy1"))
    var lancaNode = SKSpriteNode(texture: SKTextureAtlas(named: "Lanca-Attack").textureNamed("lanca-odessa-attackframe1"))
    //var lancaNode = SKSpriteNode(texture: SKTexture(imageNamed: "lanca-odessa-attackframe1"))
    
    var hud = SKNode()

    var mapa: Mapa?
    var HUDNode = HUD()
    var movements = Movimentacao()

    var posicoesHoplita : [CGPoint] = []
    
    
    var homeButton =  UIButton()
    var resumeButton =  UIButton()
    var fundoPause = SKSpriteNode()
    var pauseLabel = SKLabelNode()
    
    
    
    // Private
    private var modules: [SKSpriteNode] = []
    private var modulesInitialPositions: [CGFloat] = []
    private var placedEnemies: [SKSpriteNode] = []
    private var enemiesInCurrentModule: [SKSpriteNode] = []
    private var inimigosNode: [[SKSpriteNode]] = []

    // Camera
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
    var primeiro = CGFloat()
    var moduloInicial = CGFloat()
    var posicaoBandeira = CGFloat()
    
    let MaxHealth = 250
    var playerHP = 250
    var enemyHP = 100
    let HealthBarWidth: CGFloat = screenWidth*0.346
    let HealthBarWE: CGFloat = 40
    let HealthBarHeight: CGFloat = 7
    let HealthBarHO: CGFloat = screenHeight*0.02
    
    var attacking = false
    var atacou = false
    var isTouchingEnemy = false
    var inimigoSendoTocado = SKSpriteNode()
    
    //bonfires
    var pedra1 = SKSpriteNode(texture: SKTexture(imageNamed: "bonfire"))
    var pedra2 = SKSpriteNode(texture: SKTexture(imageNamed: "bonfire"))

    //numero Fase
    
    var levelLabel: SKLabelNode!  //label level
    var morreu = false
    
    var  numFase: Int = 0
//    {
//        didSet{
//
//            levelLabel.text = "\(numFase)"
//        }
//    }
    
    //Booelan Hoplita Attack
    var hoplitaAttack = false
    
    //Distância
    var distancia: CGFloat?
    
    //let enemyHealthBar = SKSpriteNode()

    var inimigol = 4
    
    var nMoeda: Int = 0
    var nFase: Int = 1
    
    var labelFinal = SKLabelNode()
     
    var  pontos: Int = 0
    {
        didSet{

            HUDNode.pontosLabel.text = "\(pontos)"
        }
    }

    var temUser: Bool!
    
    var score: Int = 0
    
    public let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!

    var PosInicialInimigo: [CGFloat] = []
    
    var iniciou = false
    var correndo = false
    var correndoFinal = false
    var podeMovimentar = false
    
    var atacouDireita = false
    
    var camLimit: CGFloat = 0.0
    var camFinalLimit: CGFloat = 0.0
    var posicaoAnteriorCamera: CGFloat = 0.0
    
    //Devices
    let modelName = UIDevice.current.modelName
    
    var numInimigosFase = 0
    var numInimigosDerrotados = 0
    var derrotouTodosInimigos = false
    
    //let bnb = SKSpriteNode(imageNamed: "expences-button-png-hi")
    
    override func sceneDidLoad(){
        
        
        numFase += 1
        
       // bnb.size = bnb.size*0.2
       // addChild(bnb)
        
       
        print("did load : \(numFase)")
        
//        recoverData(context: context)
       
        //Core Data
        context = appDelegate.persistentContainer.viewContext
        recoverData(context: context)
//        if (temUser == nil){
//
//            print("numero moedas: \(nMoeda)")
//          //  HUDNode.pontosLabel.text = "\(nMoeda)"
//        }
       
        
        
        

        // Mapa
        mapa = createMap()
        let floor = organizeMap()
        floor.physicsBody?.isDynamic = false
        addChild(floor)
        
        // Inicializa as animações
        movements.setMovements()
        movements.setAction(player: playerNode, velocity: velocityX)
        
        //Incializa Parallax
        //parallax.setParallax()
     
        // Player
        playerNode.size = CGSize(width: size.height/2, height: size.height/2)
        playerNode.position = CGPoint(x: modulesInitialPositions[0] + playerNode.size.width*0.4/2, y: 400)
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: playerNode.size.width*0.4, height: playerNode.size.height*0.85))
        //playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.zPosition = 1
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = PhysicsCategory.odessa
        playerNode.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        playerNode.name = "player"
        addChild(self.playerNode)
        idleOdessa()

        //Lança
        lancaNode.size = CGSize(width: size.height/2, height: size.height/2)
        lancaNode.name = "lancaNode"
      //  lancaNode.physicsBody?.categoryBitMask = PhysicsCategory.lanca
        lancaNode.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        
        // Background
        background = SKSpriteNode(texture: SKTextureAtlas(named: "Background").textureNamed("fundo"))
        background.zPosition = -6
        background.setScale(0.5)
        
        // Set gestures into HUD buttons
        HUDNode.buttonConfiguration(screenSize: UIScreen.main.bounds.size, camera: cam)
        hud = HUDNode.getHUDNode()
 
        ultimo = modulesInitialPositions.last!
        primeiro = modulesInitialPositions[1]
        moduloInicial = modulesInitialPositions[0]
    
        
        // MARK: Camera
        camera = cam
        addChild(cam)
        cam.addChild(hud)
        cam.addChild(background)
        
        cam.position.x = modulesInitialPositions[0] + screenSize.width + modules[0].size.width*0.20
        cam.position.y = 120
        
        // limite para a camera voltar
        //camLimit = cam.position.x - screenSize.width*0.3
        posicaoAnteriorCamera = cam.position.x
        
        // Limite que a camera pode voltar até o inicio da fase
        camLimit = moduloInicial + screenSize.width
        camFinalLimit = (modules.last?.position.x)!

        //Bonfires
        setInicialBonfire()
        setFinalBonfire()
       
        
        // Pegar o primeiro modulo e colocar os inimigos nas posições dele
        //placeEnemies()
        modulesInitialPositions.remove(at: 0)
        modules.remove(at: 0)
        
        iniciou = true

    }

    override func didMove(to view: SKView) {
        
        //Core Data
        context = appDelegate.persistentContainer.viewContext
        recoverData(context: context)
    
        if (temUser == true){
            pontos = nMoeda
            numFase = nFase
        }
        
        //setScore()
        updateHealthBar(node: HUDNode.playerHealthBar, withHealthPoints: MaxHealth)
        
        physicsWorld.contactDelegate = self
        
      
        // pedra inicial
         setLevelLabel(position: CGPoint(x: cam.position.x - screenSize.width*0.7, y: screenHeight*0.800))
        
        // pedra final
        setLevelLabel(position: CGPoint(x: modulesInitialPositions.last! + ((modules.last?.size.width)! * 0.7), y: screenHeight*0.800))
        
  
        // cam.addChild(parallax.frente)
        // cam.addChild(parallax.meio)
        
        let zoomOutAction = SKAction.scale(to: 2.0, duration: 0)
        cam.run(zoomOutAction)
        
        
        //randomXPos()
        
        // cam.addChild(ParallaxScene().parallaxNode)
        // cam.addChild(ParallaxScene().parallaxNode)
        
        
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
            
            if (self.podeMovimentar){
                self.joystickInUse = true
                self.startTime = Date().timeIntervalSinceReferenceDate
                self.stopTimer = false
                self.runOdessa()
            }
        }
        
        joystick?.trackingHandler = {
            
            if (self.podeMovimentar){
                if (self.angle >= 60 && self.angle <= 120){
                    
                    let rightScale = SKAction.scaleX(to: 1, duration: 0)
                    self.playerNode.run(rightScale)
                    
                } else if (self.angle >= 240 && self.angle <= 300){
                    
                    let leftScale = SKAction.scaleX(to: -1, duration: 0)
                    self.playerNode.run(leftScale)
                }
            }
        }
        
        joystick?.stopHandler = {
            
            if (self.podeMovimentar){
                self.joystickInUse = false
                self.stopTimer = false
                self.playerNode.removeAction(forKey: "repeatForever")
                let playerTexture = SKTextureAtlas(named: "Idle").textureNamed("Odessa-idle-frame1")
                self.playerNode.texture = playerTexture
                self.currentOdessaIdleSprite = 1
                //self.playerNode.physicsBody = SKPhysicsBody(texture: self.playerNode.texture! , size: CGSize(width: self.playerNode.size.width, height: self.playerNode.size.height))
                self.playerNode.removeAction(forKey: "runOdessa")
            }
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
        
        if (podeMovimentar){
            
            for t in touches {
                
                self.touchDown(atPoint: t.location(in: cam))
                location = t.location(in: cam)
                
                if (HUDNode.attackButtonNode.frame.contains(location)) && attack == false && block == false {
                    
                    attack = true
                    
                    attacking = true
                    atacou = true
                    
                    
                    let animateAction = SKAction.animate(with: movements.attackArray, timePerFrame: 0.08, resize: false, restore: false)
                    
                    let animateLanca = SKAction.animate(with: self.movements.lancaAttack, timePerFrame: 0.08, resize: false, restore: false)
                    
                    
                    let addLanca = SKAction.run({
                        
                        self.playerNode.addChild(self.lancaNode)
                        self.lancaNode.position = CGPoint(x: 20, y: 0)
                        self.lancaNode.zPosition = -1
                        self.lancaNode.size = CGSize(width: 240 * 0.75, height: 250 * 0.75)
                        
                        
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
                        
                        self.attacking = false
                        
                        
                        
                    })
                    
                    
                    let group = SKAction.group([animateAction, addLanca])
                    let sequence = SKAction.sequence([group,end])
                    self.playerNode.run(sequence, withKey: "attackAction")
                    
                    
                }
                
                //MARK: PAUSE
                if (HUDNode.pauseButtonNode.frame.contains(location)){
                    
                    fundoPause = SKSpriteNode(texture: SKTexture(imageNamed: "quadradoBranco"))
                    fundoPause.size = CGSize(width: 600, height: 500)
                    fundoPause.position = CGPoint(x: cam.position.x, y: cam.position.y)
                    fundoPause.zPosition = 3
                 //   addChild(fundoPause)
                    
                //    pauseLabel = SKLabelNode(fontNamed: "Arial")
                    pauseLabel.horizontalAlignmentMode = .center
                    pauseLabel.text = "Paused"
                    pauseLabel.position = CGPoint(x: cam.position.x, y: cam.position.y * 2)
                    pauseLabel.fontSize = 60
                    pauseLabel.zPosition = 4
                    pauseLabel.color = UIColor.black
                    
                    addChild(pauseLabel)
                    //fundoPause.addChild(pauseLabel)
                
                    let image = UIImage(named: "continue")
                    resumeButton.setImage(image, for: .normal)
                    resumeButton.frame.origin = CGPoint(x: cam.position.x/4, y: cam.position.y)
                    resumeButton.imageView?.contentMode = .scaleAspectFit
                    resumeButton.frame.size = CGSize(width: 200, height: 90)
                    resumeButton.addTarget(self, action: #selector(tirarPauseAction), for: UIControlEvents.touchUpInside)
                    self.view?.addSubview(resumeButton)
                
                    
                    let imageHome = UIImage(named: "homeButton")
                    homeButton.setImage(imageHome, for: .normal)
                    homeButton.frame.origin = CGPoint(x: cam.position.x/4, y: cam.position.y/1.5)
                    homeButton.frame.size = CGSize(width: 200, height: 90)
                    homeButton.imageView?.contentMode = .scaleAspectFit
                    homeButton.addTarget(self, action: #selector(irPraHomeAction), for: UIControlEvents.touchUpInside)
                    
                    self.view?.addSubview(homeButton)
                    
                    playerNode.isPaused = true
                    podeMovimentar = false
                    self.view?.isPaused = true
                    
                     for enemy in placedEnemies {
                        enemy.isPaused = true
                    }
  
                }
                
               

                if (HUDNode.blockButtonNode.frame.contains(location)) && attack == false && block == false && longBlock == false {
                    
                    block = true
                    fingerIsTouching = true
                    
                    let animateAction = SKAction.animate(with: movements.blockArray, timePerFrame: 0.2, resize: false, restore: false)
                    
                    let animateLanca = SKAction.animate(with: self.movements.lancaBlock, timePerFrame: 0.2, resize: false, restore: false)
                    
                    let addLanca = SKAction.run({
                        
                        self.playerNode.addChild(self.lancaNode)
                        self.lancaNode.position = CGPoint(x: 20, y: 0)
                        self.lancaNode.zPosition = -1
                        self.lancaNode.size = CGSize(width: 240 * 0.75, height: 250 * 0.75)
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
                    
                    //self.playerNode.run(movements.jumpAction, withKey: "repeatAction")
                    //self.jumpStartTime = Date().timeIntervalSinceReferenceDate
                    
                    jump = true
                    
                    var impulsoArray = [SKTexture]()
                    var puloCimaArray = [SKTexture]()
                    var puloBaixoArray = [SKTexture]()
                    
                    for i in 1...2 {
                        impulsoArray.append(SKTextureAtlas(named: "Jump").textureNamed("odessaJumpframe\(i)"))
                    }
                    
                    puloCimaArray.append(SKTextureAtlas(named: "Jump").textureNamed("odessaJumpframe3"))
                    
                    for i in 4...6 {
                        puloBaixoArray.append(SKTextureAtlas(named: "Jump").textureNamed("odessaJumpframe\(i)"))
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
                    
                    //self.playerNode.removeAction(forKey: "runOdessa")
                    self.playerNode.run(jumpAction, withKey: "jumpAction")
                    
                }
                
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            if (podeMovimentar){
                
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
    
    
    //MARK: UPDATE
    
    override func update(_ currentTime: TimeInterval) {
        
        // Limite que a camera pode voltar - conforme ela avança o jogo
//        if (cam.position.x > posicaoAnteriorCamera){
//            posicaoAnteriorCamera = cam.position.x
//            camLimit = cam.position.x - screenSize.width*0.3
//        }
        
        
        
        
        
        //Fazer a odessa andar até o centro da camera
        if (iniciou == true) {
            
            joystick?.removeFromSuperview()
            
            HUDNode.attackButtonNode.isHidden = true
            HUDNode.jumpButtonNode.isHidden = true
            
            playerNode.position.x += 4.5//2.6
            
            if (correndoFinal == false){
                runOdessa()
                correndoFinal = true
            }
            
            if (playerNode.position.x >= cam.position.x/*moduloInicial + screenSize.width*/){
                playerNode.removeAction(forKey: "runOdessa")
                iniciou = false
                podeMovimentar = true
            
                HUDNode.attackButtonNode.isHidden = false
                HUDNode.jumpButtonNode.isHidden = false
             
                view?.addSubview(joystick!)
                
                
            }
        }
   
        // Põe inimigos na tela conforme a Odessa anda -- DESBLOQUEAR ISSO
        if (!modulesInitialPositions.isEmpty){
            if ((cam.position.x + self.size.width) >= modulesInitialPositions[0]){
                if (modulesInitialPositions.count != 1) {   // não é o ultimo modulo
                    placeEnemies()
                    modulesInitialPositions.remove(at: 0)
                }

            }
        }
        
        //Fazer os Hoplitas pularem todas as vezes que ele ficar mais de x segundos na msm posição
        
        for enemy in placedEnemies {
            
            let posAnterior = enemy.value(forAttributeNamed: "PosicaoAnterior")!.floatValue
            let inimigoAntes = Float(enemy.position.x + (enemy.size.height/2)/2)
            let inimigosDepois = Float(enemy.position.x - (enemy.size.height/2)/2)
            
            print(posAnterior, "posAnterior")
            print(inimigoAntes, "inimigoAntes")
            print(inimigosDepois, "inimigosDepois")
            
            if (Float(enemy.position.x) <= posAnterior + 1.0 && Float(enemy.position.x) >= posAnterior - 1.0 && iniciou == false) && isTouchingEnemy == false && inimigoSendoTocado != enemy {
                
                print("pulou")
                
                if (enemy.value(forAttributeNamed: "jumping")?.floatValue == 0){
                    print("pulou de verdade")
                    jumpHoplita(enemy: enemy)
                }
            
                

                /*
                print("entrou aqui")
                
                let tempoAntigo = enemy.value(forAttributeNamed: "tempoEspera")?.floatValue
                enemy.setValue(SKAttributeValue.init(float: tempoAntigo! + 1), forAttribute: "tempoEspera")
                
                if (Double((enemy.value(forAttributeNamed: "tempoEspera")?.floatValue)!) >= 60.0){
                    
                    jumpHoplita(enemy: enemy)
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "tempoEspera")
                }*/
                
            }
            print("kd")
            enemy.setValue(SKAttributeValue.init(float: Float(enemy.position.x)), forAttribute: "PosicaoAnterior")
            
            /*else {
                enemy.setValue(SKAttributeValue.init(float: Float(enemy.position.x)), forAttribute: "PosicaoAnterior")
                enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "tempoEspera")
            }*/
        }
        
        
     //   print("\(attacking)")
        
    //    attacking = true
//
        
     //   for enemy in placedEnemies {
        
            
//
//            enemyHealthBar.position = CGPoint(
//                x: enemy.convert(enemy.position, to: self).x,
//                y: enemy.convert(enemy.position, to: self).y + enemy.size.height / 2
//            )
//
//            self.addChild(enemyHealthBar)
        
//            print("\(enemyHealthBar.position), POSICAO DA BARRA")
//            print(enemy.convert(enemy.position, to: self) , " POSICAO INIMIGO")
            
 //       }
        
        // Retira inimigos da tela quando a Odessa se afasta muito -- DESBLOQUEAR ISSO
//        for enemy in placedEnemies {
//            if (enemy.convert(enemy.position, to: self).x < (cam.position.x - 2*self.size.width)) && !cam.contains(enemy) {
//                enemy.removeAllActions()
//                enemy.removeAllChildren()
//                enemy.removeFromParent()
//                placedEnemies.remove(at: placedEnemies.index(of: enemy)!)
//            }
//        }
        
        
        if (playerNode.position.x > modulesInitialPositions.last! + 200){

            //goToGameScene()
//            let nextScene = VictoryScene(size: self.scene!.size)
//
//            nextScene.scaleMode = self.scaleMode
//            nextScene.backgroundColor = UIColor.black
//            joystick?.removeFromSuperview()
//            self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 0.5))

         //   VictoryHandler()
            
        }
        
        if (attacking == true){
            if (atacou == true && isTouchingEnemy == true){
                for enemies in placedEnemies{
                    if (enemies == inimigoSendoTocado) {
                        
                        let enemyPosition = enemies.convert(enemies.position, to: self).x/2 + PosInicialInimigo[placedEnemies.index(of: enemies)!]/2
                        let playerPosition = playerNode.position.x
                        
                        if (enemyPosition >= playerPosition + (playerNode.size.width*0.4/2) ) {
                            atacouDireita = false
                            odessaAttackedEnemy(odessa: playerNode, enemy: inimigoSendoTocado)
                            atacou = false
                        } else if (enemyPosition < playerPosition - (playerNode.size.width*0.4/2)){
                            atacouDireita = true
                            odessaAttackedEnemy(odessa: playerNode, enemy: inimigoSendoTocado)
                            atacou = false
                        }
                    }
                }
            }
        }
       
      
        //Hoplita Attack
        
        for enemy in placedEnemies {
        
            let index = CGFloat(placedEnemies.index(of: enemy)! + 1)
            let enemyPosition = enemy.convert(enemy.position, to: self).x/2 + PosInicialInimigo[placedEnemies.index(of: enemy)!]/2
            let playerPosition = playerNode.position.x
            //let playerPosition = playerNode.convert(playerNode.position, to: enemy.parent!).x
            //let enemyPosition = enemy.position.x
            
            // bnb.position.x = enemyPosition
            // bnb.position.y = enemy.position.y
            
            enemy.convert(enemy.position, to: self)
            
            distancia = enemyPosition - playerPosition
            
            // Odessa dá um bounce pra outro lado
            if (enemyPosition >= playerPosition - (playerNode.size.width*0.4) && enemyPosition <= playerPosition + (playerNode.size.width*0.4/2) && (isTouchingEnemy && inimigoSendoTocado == enemy)) {
                
                // Odessa está em cima do inimigo 
                
            }
            
            if (enemyPosition >= playerPosition - (playerNode.size.width*0.4) && enemyPosition <= playerPosition + (playerNode.size.width*0.4/2) || (isTouchingEnemy && inimigoSendoTocado == enemy)){
                
                if (enemy.value(forAttributeNamed: "Attack")?.floatValue == 0){
                    enemy.removeAction(forKey: "Attack")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "Attack")
                    hoplitaAttackAnimation(enemy: enemy)
                } else if (enemy.value(forAttributeNamed: "AttackInvertida")?.floatValue == 0){
                    enemy.removeAction(forKey: "AttackInvertida")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "AttackInvertida")
                    hoplitaAttackAnimationInvertida(enemy: enemy)
                } else if (enemy.value(forAttributeNamed: "animationInvertida")?.floatValue == 1){
                    enemy.removeAction(forKey: "repeatForeverInvertido")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "animationInvertida")
                    hoplitaAttackAnimationInvertida(enemy: enemy)
                } else if (enemy.value(forAttributeNamed: "animation")?.floatValue == 1){
                    enemy.removeAction(forKey: "repeatActionAnimation")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "animation")
                    hoplitaAttackAnimation(enemy: enemy)
                }
                
            } else if (enemyPosition > playerPosition + (playerNode.size.width*0.4/2)) {

                enemy.texture = SKTexture(image: UIImage(named: "enemy1")!)
                
                if (enemy.value(forAttributeNamed: "Attack")?.floatValue == 0){
                    enemy.removeAction(forKey: "Attack")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "Attack")
                }
                if (enemy.value(forAttributeNamed: "AttackInvertida")?.floatValue == 0){
                    enemy.removeAction(forKey: "AttackInvertida")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "AttackInvertida")
                }
                if (enemy.value(forAttributeNamed: "animationInvertida")?.floatValue == 1){
                    enemy.removeAction(forKey: "repeatForeverInvertido")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "animationInvertida")
                }
                if (enemy.value(forAttributeNamed: "animation")?.floatValue == 0) && iniciou == false {
                    hoplitaWalkAnimation(enemy: enemy)
                }

                if (iniciou == false){
                    enemy.position.x -= 0.7*3
                }

            } else if (enemyPosition < playerPosition - (playerNode.size.width*0.4/2)){

                enemy.texture = SKTexture(image: UIImage(named: "hoplitaInvertido")!)
                
                if (enemy.value(forAttributeNamed: "Attack")?.floatValue == 0){
                    enemy.removeAction(forKey: "Attack")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "Attack")
                }
                if (enemy.value(forAttributeNamed: "AttackInvertida")?.floatValue == 0){
                    enemy.removeAction(forKey: "AttackInvertida")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "AttackInvertida")
                }
                if (enemy.value(forAttributeNamed: "animation")?.floatValue == 1){
                    enemy.removeAction(forKey: "repeatActionAnimation")
                    enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "animation")
                }
                if (enemy.value(forAttributeNamed: "animationInvertida")?.floatValue == 0) && iniciou == false {
                    hoplitaWalkAnimationInvertido(enemy: enemy)
                }

                if (iniciou == false){
                    enemy.position.x += 0.7*3
                }
            }
            
        }
        
        // Tempo
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        // Update delta time
        deltaTime = currentTime - lastFrameTime
        
        // Set last frame time to current time
        lastFrameTime = currentTime
        
        
      //  self.moveSprite(sprite: parallax.frente, nextSprite: parallax.frenteNext, speed: 10.0)
      //  self.moveSprite(sprite: parallax.meio, nextSprite: parallax.frenteNext, speed: 5.0)
        
        // Só pode se movimentar depois que acabar a animação inicial
        if podeMovimentar {
            
            if (self.angle >= 60 && self.angle <= 120) && joystickInUse == true && longBlock == false {
                
                self.playerNode.position.x += self.displacement*3
                
            } else if (self.angle >= 240 && self.angle <= 300) && joystickInUse == true && longBlock == false{
                
                // não permite que a odessa ande para antes do limite da camera
                if (playerNode.position.x - playerNode.size.width*0.4/2 >= cam.position.x - screenSize.width) {
                    self.playerNode.position.x -= self.displacement*3
                }
                
            }
        }
        
        // Camera acompanhando a Odessa
        if (iniciou == false && playerNode.position.x >= camLimit && playerNode.position.x <= camFinalLimit){
            cam.position = CGPoint(x: playerNode.position.x, y: 120)
        }
        
        if (playerNode.position.x < pedra2.position.x /*modulesInitialPositions.last! + 500*/){
      
            pedra2Animation()
            
        }
        
        
        if (numInimigosFase == numInimigosDerrotados){
            derrotouTodosInimigos = true
        } else {
            labelFinal.text = "\(numInimigosDerrotados)/\(numInimigosFase)"
        }
        
        // Enquanto todos os inimigos não forem todos mortos a fase não acaba e a
        // label em cima da pedra tem o contador de inimigos, quando ele mata todos
        // o contador dos inimigos troca para o nível da fase (ou nada at all)
//        if (playerNode.position.x >= pedra2.position.x) {
//            labelFinal.text = "\(numFase + 1)"
//        }
        
        if (playerNode.position.x > modulesInitialPositions.last! + 700 && derrotouTodosInimigos){
            
           // VictoryHandler()
            
            playerNode.position.x += 2.6
            podeMovimentar = false
            
            if (correndo == true){
              
                runOdessa()
                correndo = false
            }
            cam.position.x = modulesInitialPositions.last! + 700
      
            if (playerNode.position.x > modulesInitialPositions.last! + (modules.last?.size.width)!){
                goToGameScene()
            }
  
        }
        if (playerNode.position.x < pedra1.position.x){
            
            pedra1Animation()
            
        }
        
        
        
        // Game Over
        if (playerNode.position.y < -239){
            GameOverHandler()
        }
        
        if (fingerIsTouching == true) && (longBlock == false) && podeMovimentar {
            
            longBlockEndTime = Date().timeIntervalSinceReferenceDate
            longBlockDt = Double(longBlockEndTime - longBlockStartTime)
            
            if longBlockDt > 0.6 {
                odessaLongBlockAnimation()
            }
            
        }
        
    }
    
    func goToGameScene(){
        
        print("aaa")
        
     
        
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size) // create your new scene
        
//        let transition = SKTransition.doorsCloseHorizontal(withDuration: 3.0)
//        let transition = SKTransition.fade(withDuration: 0.0)
//


        let transition = SKTransition.fade(withDuration: 0.0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = SKSceneScaleMode.fill
        atualizaBanco()
        self.view!.presentScene(gameScene, transition: transition)
       
        
        
    }
    
    // Game Over
    func GameOverHandler(){
        
        let nextScene = GameOverScene(size: self.scene!.size)
        // let nextScene = VictoryScene(size: self.size)
        nextScene.scaleMode = self.scaleMode
        nextScene.backgroundColor = UIColor.black
        joystick?.removeFromSuperview()
        self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 1.5))
    }
    
    
    func VictoryHandler(){
       atualizaBanco()
  
        let nextScene = VictoryScene(size: self.scene!.size)
        nextScene.scaleMode = self.scaleMode
        nextScene.backgroundColor = UIColor.black
        joystick?.removeFromSuperview()
        self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 0.5))
        
    }
    
    // Place Enemies in module
    func placeEnemies(){
        
        for enemy in inimigosNode[0] {
            
            modules[0].addChild(enemy)
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "animationInvertida")
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "animation")
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "AttackInvertida")
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "Attack")
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "PosicaoAnterior")
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "tempoEspera")
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "jumping")
            placedEnemies.append(enemy)
            PosInicialInimigo.append(enemy.convert(enemy.position, to: self).x)
            //hoplitaWalkAnimation(enemy: enemy)
            inimigosNode[0].remove(at: 0)
        }
        
        if (inimigosNode[0].isEmpty){
            inimigosNode.remove(at: 0)
        }
        
        modules.remove(at: 0)
    }
    
    func randomXPos() {
        
        for numModulo in inimigosNode {
            for enemies in numModulo {
                
                let moduloSprite = enemies.parent as! SKSpriteNode
                
                let modInicialPos = moduloSprite.position.x - moduloSprite.size.width/2
                let modFinalPos = moduloSprite.position.x + moduloSprite.size.width/2
                let position = CGFloat(arc4random_uniform(UInt32(modFinalPos))) + modInicialPos
                
                enemies.position.x = position
                
            }
            
        }
        
    }
    
    
    // Get Enemies from all modules
    func getModulesEnemy(modulo: ModuloMapa) {
        var moduleWaves = Reader().GetModuleSets(ModuleID: modulo.IDModulo)
        let item = Int(arc4random_uniform(UInt32(moduleWaves.count) - 1))
        var i = 0
        
        for inimigo in moduleWaves[item].inimigos {
            
            let texture = SKTextureAtlas(named: "Inimigos").textureNamed(inimigo.imgName)
            
            let inimigoNode = SKSpriteNode(texture: texture) // 75% antes
            inimigoNode.size = CGSize(width: size.height/2, height: size.height/2)
            inimigoNode.position = CGPoint(x: Double(inimigo.posInModuleX!), y: Double(inimigo.posInModuleY!) + Double(texture.size().height))
            inimigoNode.zPosition = 1
            inimigoNode.anchorPoint = CGPoint(x: 0.5, y: 0.43)
            inimigoNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: inimigoNode.size.width*0.4, height: inimigoNode.size.height*0.72))

            inimigoNode.physicsBody?.allowsRotation = false
            inimigoNode.physicsBody?.usesPreciseCollisionDetection = true
            inimigoNode.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            inimigoNode.physicsBody?.contactTestBitMask = PhysicsCategory.odessa
            //inimigoNode.physicsBody?.collisionBitMask = PhysicsCategory.odessa //faz inimigo não colidir com ele mesmo
            inimigoNode.name = "inimigo"
            
            let HealthBar = createEnemyHealthBar()
            HealthBar.position = CGPoint(x: Double(inimigo.posInModuleX!), y: Double(inimigo.posInModuleY!) + Double(texture.size().height)/4)
            
            inimigoNode.addChild(HealthBar)
            
            inimigoNode.setValue(SKAttributeValue.init(float: Float(100 + (5 * numFase))), forAttribute: "life")
            
            //Inimigo Size
//            inimigoNode.size = CGSize(width: size.height/2, height: size.height/2)
            
            enemiesInCurrentModule.append(inimigoNode)
            i += 1
            
            numInimigosFase += 1
            
            if (i == moduleWaves[item].inimigos.count){
                inimigosNode.append(enemiesInCurrentModule)
                enemiesInCurrentModule.removeAll()
            }
        }
    }
    
    func createEnemyHealthBar() -> SKSpriteNode {
        
        //Barra Inimigo
        let enemyHealthBar = SKSpriteNode()
        
        let barSize = CGSize(width: HealthBarWE, height: HealthBarHeight);
        let fillColor = UIColor(red: 113.0/255, green: 202.0/255, blue: 53.0/255, alpha:1)
        let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        borderColor.setStroke()
        
        let borderRect = CGRect(origin: CGPoint(x:0, y:0), size: barSize)
        context!.stroke(borderRect, width: 1)
        fillColor.setFill()
        
        let barWidth = (barSize.width - 1) * CGFloat(100) / CGFloat(100)
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        context!.fill(barRect)
        
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        enemyHealthBar.texture = SKTexture(image: spriteImage!)
        enemyHealthBar.size = barSize
        enemyHealthBar.name = "HealthBar"
        
        return enemyHealthBar
    }
    
    // Cria Mapa
    func createMap() -> Mapa {
        
        let modulosIDs: [Int] = randomizeModules()
        var modulos: [ModuloMapa] = []
        
        // Modulo Inicial
        let moduleInicial = ModuloMapa(imagemCenario: "floorEspada", IDModulo: -1, waves: [])
        modulos.append(moduleInicial)

        
        for ID in modulosIDs {
            let modulo = Reader().GetModule(ModuleID: ID)
            modulos.append(modulo)
        }
        
        // Modulo Final
        let moduleFinal = ModuloMapa(imagemCenario: "floorEspada", IDModulo: -2, waves: [])
        modulos.append(moduleFinal)

        
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
        
        let floor = SKNode()
        var floorSegments: [SKSpriteNode] = []
        var i: Int = 0
        
        for module in (mapa?.Modulos)! {
            
            let floorModule = SKSpriteNode(texture: SKTextureAtlas(named: "Floor").textureNamed(module.imagemCenario))
            floorModule.position.x = floor.calculateAccumulatedFrame().size.width + (floorModule.size.width/2)
            floorModule.position.y = SetYFloorPosition(floor: floorModule)
            floorModule.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floorModule.frame.width, height: floorModule.frame.height))
            floorModule.physicsBody = SKPhysicsBody(texture: floorModule.texture!, size: (floorModule.texture?.size())!)
            floorModule.physicsBody?.affectedByGravity = false
            floorModule.physicsBody?.isDynamic = false
            floorModule.physicsBody?.categoryBitMask = PhysicsCategory.chao
            floorModule.name = "chao"
            floorSegments.append(floorModule)
            floor.addChild(floorModule)
          
            
            modulesInitialPositions.append(floor.calculateAccumulatedFrame().size.width - floorModule.size.width)
            // Modulo Inicial e Final
            if (module.IDModulo != -1 && module.IDModulo != -2) {
                getModulesEnemy(modulo: module)
            }

            modules.append(floorModule)
            
            if (i > 0){
                SKPhysicsJointFixed.joint(withBodyA: floorSegments[i-1].physicsBody!, bodyB: floorSegments[i].physicsBody!, anchor: CGPoint(x: 0.5, y: 0.5))
            }
            
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
        
        return CGFloat(newPosition)
    }
    
    
    // Odessa
    
    func odessaLongBlockAnimation(){
        
        longBlock = true
        
        var longBlockArray = [SKTexture]() //Odessa long Block
        var lancaLongBlock = [SKTexture]() //Lança long Block
        
        for i in 1...3 {
            longBlockArray.append(SKTextureAtlas(named: "Odessa-Block").textureNamed("Odessa-block-hold-frame\(i)"))
        }
        
        for i in 1...3 {
            lancaLongBlock.append(SKTextureAtlas(named: "Lanca-Block").textureNamed("Lanca-Odessa-block-hold-frame\(i)"))
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
            
            if (spriteToMove.frame.maxX < self.frame.minX) {
                
                spriteToMove.position = CGPoint(x: spriteToMove.position.x - spriteToMove.size.width * 2, y: spriteToMove.position.y)
            }
            
        }
    }
        
        
    func idleOdessa(){
            var idleArray = [SKTexture]()
            
            for i in 1...4 {
                idleArray.append(SKTexture(imageNamed: "Odessa-idle-frame\(i)"))
            }
        
        
        let animateOdessa = SKAction.animate(with: idleArray, timePerFrame: 0.25, resize: false, restore: false)
        
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
 
    //MARK: Colisao
    
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "inimigo") {
            isTouchingEnemy = false
            inimigoSendoTocado = SKSpriteNode()
            
            //print("naum to tocano naum")
            
            // execute code to respond to object hitting ground
        }
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
        
//        print(firstBody.node?.name)
//        print(secondBody.node?.name)
        
//        print("\(attacking)")
        
       
        
        if firstBody.node?.name == "player" && secondBody.node?.name == "inimigo" {
            
            isTouchingEnemy = true
            inimigoSendoTocado = secondBody.node as! SKSpriteNode

//         if (( firstBody.categoryBitMask == PhysicsCategory.odessa) && (secondBody.categoryBitMask == PhysicsCategory.enemy)){
            
        }
        
 
       
       
        
    }
    
    func odessaAttackedEnemy(odessa:SKSpriteNode, enemy:SKSpriteNode) {    // aconteceu colisão entre odessa e o inimigo
        
        enemy.setValue(SKAttributeValue.init(float: (enemy.value(forAttributeNamed: "life")?.floatValue)! - 25), forAttribute: "life")
        
        // Descobre o lado que a odessa atacou
        if (atacouDireita){
            enemy.physicsBody?.applyImpulse(CGVector(dx: -100.0, dy: 100.0))
        } else {
            enemy.physicsBody?.applyImpulse(CGVector(dx: 100.0, dy: 100.0))
        }

        let apagaAction = SKAction.fadeOut(withDuration: 0.09)
        let acendeAction = SKAction.fadeIn(withDuration: 0.09)
        
        let piscaAction = SKAction.sequence([apagaAction,acendeAction])
        enemy.run(piscaAction)
        
        updateEnemyLife(enemyBar: enemy.childNode(withName: "HealthBar") as! SKSpriteNode, withHealthPoints: (enemy.value(forAttributeNamed: "life")?.floatValue)!)
        

        if (Double((enemy.value(forAttributeNamed: "life")?.floatValue)!) <= 0.0){
            
            numInimigosDerrotados += 1
            
            let healthBar = enemy.childNode(withName: "HealthBar")
            healthBar?.removeFromParent()

            enemy.removeAllActions()
            enemy.removeAllChildren()
            enemy.removeFromParent()
            let i = placedEnemies.index(of: enemy)
            placedEnemies.remove(at: i!)
            PosInicialInimigo.remove(at: i!)

            pontos += 100
        }
        
    }
    
    func enemyAttackedOdessa(odessa:SKSpriteNode, enemy:SKSpriteNode) {
        
        //playerHP = max(0, playerHP - 85)//25
        
        let apagaOdessa = SKAction.fadeOut(withDuration: 0.06)
        let acendeOdessa = SKAction.fadeIn(withDuration: 0.06)
        
        let piscaOdessa = SKAction.sequence([apagaOdessa,acendeOdessa])
        playerNode.run(piscaOdessa)
        
        playerHP = max(0, playerHP - 5 - (5 * numFase))//25
        updateHealthBar(node: HUDNode.playerHealthBar, withHealthPoints: playerHP)

        if (playerHP == 0){
            morreu = true
            atualizaBanco()
            playerNode.removeFromParent()
            GameOverHandler()
            
            
        }
    }

    
    //Mark: Update das Health Bars
    
    func updateEnemyLife(enemyBar: SKSpriteNode,withHealthPoints hp: Float){
        
        let barSize = CGSize(width: HealthBarWE, height: HealthBarHeight);
        
        let fillColor = UIColor(red: 113.0/255, green: 202.0/255, blue: 53.0/255, alpha:1)
        let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
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
        enemyBar.texture = SKTexture(image: spriteImage!)
        enemyBar.size = barSize

        
    }
    
  
    
    func updateHealthBar(node: SKSpriteNode, withHealthPoints hp: Int) {
        
       
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
    
    //Mark: Physics Category

    public struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let odessa    : UInt32 = 0b1       // 1
        static let enemy     : UInt32 = 0b10      // 2
        static let chao      : UInt32 = 3          //3
      
    }
    
    
    //Mark: Hoplita Animation

    func hoplitaWalkAnimationInvertido(enemy: SKSpriteNode){
        enemy.setValue(SKAttributeValue.init(float: 1), forAttribute: "animationInvertida")
        var walkArray = [SKTexture]()
        
        for i in 1...5 {
            walkArray.append(SKTexture(imageNamed: "hoplitaCorrendoInvertido-\(i)"))
        }
        
        let animateOdessa = SKAction.animate(with: walkArray, timePerFrame: 0.15, resize: false, restore: false)
        let repeatForeverInvertido = SKAction.repeatForever(animateOdessa)
        
        enemy.run(repeatForeverInvertido, withKey: "repeatForeverInvertido")
    }
    
    func hoplitaWalkAnimation(enemy: SKSpriteNode){
        enemy.setValue(SKAttributeValue.init(float: 1), forAttribute: "animation")
        
        var walkArray = [SKTexture]()
        
        for i in 1...8 {
            walkArray.append(SKTexture(imageNamed: "hoplita_walk-frame\(i)"))
        }
        
        let animateOdessa = SKAction.animate(with: walkArray, timePerFrame: 0.15, resize: false, restore: false)
        let repeatActionAnimation = SKAction.repeatForever(animateOdessa)
        
        
        enemy.run(repeatActionAnimation, withKey: "repeatActionAnimation")
        
        let end = SKAction.run {
            enemy.removeAction(forKey: "repeatActionAnimation")
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "animation")
        }
        
        
    }
    
    func hoplitaAttackAnimationInvertida(enemy: SKSpriteNode){
        enemy.setValue(SKAttributeValue.init(float: 1), forAttribute: "AttackInvertida")
        
        var attackArray = [SKTexture]()
//        var lancaAttack = [SKTexture]()
        
        for i in 1...4 {
            attackArray.append(SKTexture(imageNamed: "soldier_attack-invertido-frame\(i)"))
        }
        
//        for i in 1...7 {
//            lancaAttack.append(SKTexture(imageNamed: "maca-soldier_attack-frame\(i)"))
//        }
        
        let animateOdessa = SKAction.animate(with: attackArray, timePerFrame: 0.145, resize: false, restore: false)
        
        let end = SKAction.run ({
            if (self.isTouchingEnemy == true){
                self.enemyAttackedOdessa(odessa:  self.playerNode, enemy: self.inimigoSendoTocado)
            }
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "AttackInvertida")
        })
        
        let sequence = SKAction.sequence([animateOdessa, end])
        enemy.run(sequence, withKey: "attack")
    }
    
    
    
    func hoplitaAttackAnimation(enemy: SKSpriteNode){
        enemy.setValue(SKAttributeValue.init(float: 1), forAttribute: "Attack")
        
        var attackArray = [SKTexture]()
        //        var lancaAttack = [SKTexture]()
        
        for i in 1...4 {
            attackArray.append(SKTexture(imageNamed: "soldier_attack-frame\(i)"))
        }
        
        //        for i in 1...7 {
        //            lancaAttack.append(SKTexture(imageNamed: "maca-soldier_attack-frame\(i)"))
        //        }
        
        let animateOdessa = SKAction.animate(with: attackArray, timePerFrame: 0.145, resize: false, restore: false)
        
        let end = SKAction.run ({
            if (self.isTouchingEnemy == true){
                self.enemyAttackedOdessa(odessa:  self.playerNode, enemy: self.inimigoSendoTocado)
            }
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "Attack")
        })
        
        let sequence = SKAction.sequence([animateOdessa, end])
        enemy.run(sequence, withKey: "attack")
    }
    
    
    //MARK: Bonfire
    
    func setInicialBonfire (){
        
        pedra1.position = CGPoint(x: cam.position.x - screenSize.width*0.7, y: screenHeight*0.385)// 8200 230
        pedra1.zPosition = -1
        pedra1.setScale(0.75)
        
        addChild(pedra1)
    }
    
    func setFinalBonfire(){
        
        pedra2.position = CGPoint(x: modulesInitialPositions.last! + ((modules.last?.size.width)! * 0.7), y: screenHeight*0.385)// 8200 230
        pedra2.zPosition = -1
        pedra2.setScale(0.75)
        
        addChild(pedra2)
    }
    
    
    func pedra1Animation (){
        
        var pedritaFogos = [SKTexture]()
        for i in 1...13 {
            pedritaFogos.append(SKTexture(imageNamed:("bonfire-frame-\(i)")))
        }
        let fogosAction = SKAction.animate(with: pedritaFogos, timePerFrame: 0.15, resize: true, restore: false)
        let repeatAction = SKAction.repeatForever(fogosAction)
        
        pedra1.run(repeatAction, withKey: "repeatAction")
        
        
        
    }
    
    func pedra2Animation(){
        
        var pedritaFogos = [SKTexture]()
        for i in 1...13 {
            pedritaFogos.append(SKTexture(imageNamed:("bonfire-frame-\(i)")))
        }
        let fogosAction = SKAction.animate(with: pedritaFogos, timePerFrame: 0.15, resize: true, restore: false)
        let repeatAction = SKAction.repeatForever(fogosAction)
        
        pedra2.run(repeatAction, withKey: "repeatAction")
        
        
        
    }
    
    //MARK: Level Label
    
    func setLevelLabel(position: CGPoint){
        
        levelLabel = SKLabelNode(fontNamed: "Montserrat")
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.text = "\(numFase)"
        levelLabel.position = position
        levelLabel.fontSize = 60
        levelLabel.zPosition = -1
        levelLabel.color = UIColor.white
        
        addChild(levelLabel)
        
        if (position == CGPoint(x: modulesInitialPositions.last! + ((modules.last?.size.width)! * 0.7), y: screenHeight*0.800)){
            levelLabel.text = "\(numInimigosDerrotados)/\(numInimigosFase)"
            labelFinal = levelLabel
        }
    }
    
    
    // Jump hoplita
    func jumpHoplita(enemy: SKSpriteNode){
        
        enemy.setValue(SKAttributeValue.init(float: 1), forAttribute: "jumping")
        
        var impulsoArray = [SKTexture]()
        var puloCimaArray = [SKTexture]()
        var puloBaixoArray = [SKTexture]()
        
        for i in 1...2 {
            impulsoArray.append(SKTextureAtlas(named: "Hoplita_Jump").textureNamed("hoplita-jump-frame\(i)"))
        }
        
        puloCimaArray.append(SKTextureAtlas(named: "Hoplita_Jump").textureNamed("hoplita-jump-frame3"))
        
        for i in 4...6 {
            puloBaixoArray.append(SKTextureAtlas(named: "Hoplita_Jump").textureNamed("hoplita-jump-frame\(i)"))
        }
        
        let jumpUp = SKAction.moveBy(x: 0, y: 240, duration: 0.3)
        let fallBack = SKAction.moveBy(x: 0, y: 0, duration: 0.3)
        
        let impulso = SKAction.animate(with: impulsoArray, timePerFrame: 0.1)
        let puloCima = SKAction.animate(with: puloCimaArray, timePerFrame: 0.05)
        let puloBaixo = SKAction.animate(with: puloBaixoArray, timePerFrame: 0.10)
        let group = SKAction.group([puloBaixo, fallBack])
        
        let endMoviment = SKAction.run({
            
            enemy.setValue(SKAttributeValue.init(float: 0), forAttribute: "jumping")
            self.jump = false
            enemy.removeAction(forKey: "jumpAction")
            
            if self.joystickInUse == true {
                self.runOdessa()
            }
            
        })
        
        let jumpAction = SKAction.sequence([impulso,puloCima, jumpUp, group, endMoviment])
        
        //self.playerNode.removeAction(forKey: "runOdessa")
        enemy.run(jumpAction, withKey: "jumpAction")
        
    }
    
    
    
    //MARK: Core Data

    func atualizaBanco(){     //rezetar tudo ao clicar no new game

        score += pontos
       // numFase += 1
        if (morreu == false){
            numFase += 1
        }

        print("\(pontos)")
        print("\(score)")
        print("\(temUser)")
        print(" num fase data \(numFase)")
        print("nFase \(nFase)")

        if (temUser == true){
            if (score > nMoeda){
                print("é maior")
                print("atualiza bd")
                updateData (context: context, score: score,level: numFase)
                score = 0

            }
            
            else if (nFase < numFase){
                
                updateData (context: context, score: score,level: numFase)
       
            }
    
            else {
                print("n moeda é maior")
                score = 0
            }


        }
        else {  // só entra quando n tem user no bd
            print("saved")
            storeData(context: context, moeda: score, level: numFase)
            score = 0

        }

    }
    
  
    func storeData(context: NSManagedObjectContext, moeda: Int, level: Int){

        if (temUser == nil){
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
            newUser.setValue(moeda, forKey: "coins")
            newUser.setValue(level, forKey: "level")
        }

        do {
            try context.save()
            print("SAVED")
        }
        catch{
            print("NOT SAVED")
        }
        
    }
    
    func recoverData (context: NSManagedObjectContext){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
               
                for result in results as! [NSManagedObject] {
                    if let moeda = result.value(forKey: "coins") as? Int {
                        print(moeda)
                        nMoeda = moeda
                        temUser = true
                        
                    }
                    if let level = result.value(forKey: "level") as? Int{
                        print("level \(level)")
                        nFase = level
                    }
                    
                }
            }
        }
        catch {
            print("erro")
        }
  
    }
    
    func updateData (context: NSManagedObjectContext, score: Int, level: Int){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    if let moeda = result.value(forKey: "coins") as? Int {
                        if (moeda < score){
                            result.setValue(score, forKey: "coins")
                            storeData(context: context, moeda: score, level: level)
                            print("atualizou")
                        }
                       
                    }
                    
                     if let nivel = result.value(forKey: "level") as? Int{
                    
                        if (nivel < level){
                            
                            result.setValue(level, forKey: "level")
                            print("update data \(level)")
                            storeData(context: context, moeda: score, level: level)
                            print("atualizou")
                            
                        }
                        
                        
                    }
                }
            }
        }
        catch {
            
        }

    }
    
    
  

    
    
}

//

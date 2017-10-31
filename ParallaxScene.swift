//
//  ParallaxScene.swift
//  Odessa
//
//  Created by Mariela Andrade on 31/10/17.
//  Copyright © 2017 Michelle Beadle. All rights reserved.
//

import UIKit
import GameplayKit

class ParallaxScene: SKScene {
    
    
    let parallaxNode = SKNode()
   // let frenteNode = SKNode()
    
    var meio = SKSpriteNode()
    var meioNext = SKSpriteNode()
    
    var frente  = SKSpriteNode()
    var frenteNext  = SKSpriteNode()
    
    // Time of last frame
    var lastFrameTime : TimeInterval = 0
    
    // Time since last frame
    var deltaTime : TimeInterval = 0
    
//    var cameran = SKCameraNode()

    
    override func sceneDidLoad() {
        
        meio = SKSpriteNode(imageNamed: "mid")
        meioNext = meio.copy() as! SKSpriteNode
        
        meio.position =  CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        meio.zPosition = -4

        frente = SKSpriteNode(imageNamed: "front")
        meioNext = frente.copy() as! SKSpriteNode
        
        meioNext.position = CGPoint(x: meio.position.x + meio.size.width, y: meio.position.y)
        meioNext.zPosition = -4
        
        frente.position = CGPoint(x: size.width , y: size.height + 100)
        frente.zPosition = -3
        
        frenteNext = frente.copy() as! SKSpriteNode
        frenteNext.position = CGPoint(x: frente.position.x + frente.size.width, y: frente.position.y)
        
//        parallaxNode.addChild(meio)
//        parallaxNode.addChild(meioNext)
//        parallaxNode.addChild(frente)
//        parallaxNode.addChild(frenteNext)
        
        
        
        
    }
    
    func moveSprite(sprite : SKSpriteNode, nextSprite : SKSpriteNode, speed : Float) -> Void {
        var newPosition = CGPoint(x: 0, y: 0)
        
        // For both the sprite and its duplicate:
        for spriteToMove in [sprite, nextSprite] {
            
            // Shift the sprite leftward based on the speed
            newPosition = spriteToMove.position
            newPosition.x -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            // If this sprite is now offscreen (i.e., its rightmost edge is
            // farther left than the scene's leftmost edge):
            if spriteToMove.frame.maxX < self.frame.minX {
                
                // Shift it over so that it's now to the immediate right
                // of the other sprite.
                // This means that the two sprites are effectively
                // leap-frogging each other as they both move.
                spriteToMove.position = CGPoint(x: spriteToMove.position.x + spriteToMove.size.width * 2, y: spriteToMove.position.y)
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
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
        
        // Next, move each of the four pairs of sprites.
        // Objects that should appear move slower than foreground objects.
     //   self.moveSprite(meio, nextSprite:meioNext, speed:25.0)
        self.moveSprite(sprite: meio, nextSprite:meioNext, speed:50.0)
        self.moveSprite(sprite: frente, nextSprite:frenteNext, speed:100.0)
     //   self.moveSprite(pathNode, nextSprite:pathNodeNext, speed:150.0)
    }
    
  
        
     
       
        

     
        
  
    

}

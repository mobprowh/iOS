//
//  PlayerNode.swift
//  TextShooter
//
//  Created by Kim Topley on 11/9/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import SpriteKit

class PlayerNode: SKNode {
    override init() {
        super.init()
        name = "Player \(self)"
        initNodeGraph()
        initPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveToward(location: CGPoint) {
        removeActionForKey("movement")
        removeActionForKey("wobbling")
            
        let distance = pointDistance(position, location)
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let duration = NSTimeInterval(2 * distance/screenWidth)
        
        runAction(SKAction.moveTo(location, duration: duration),
                                  withKey:"movement")
            
        let wobbleTime = 0.3
        let halfWobbleTime = wobbleTime/2
        let wobbling = SKAction.sequence([
                SKAction.scaleXTo(0.2, duration: halfWobbleTime),
                SKAction.scaleXTo(1.0, duration: halfWobbleTime)
        ])
        let wobbleCount = Int(duration/wobbleTime)
        runAction(SKAction.repeatAction(wobbling, count: wobbleCount),
                                        withKey:"wobbling")
   }
    
    override func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
        let path = NSBundle.mainBundle().pathForResource("EnemyExplosion",
                                ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(path!)
                                as! SKEmitterNode
        explosion.numParticlesToEmit = 50
        explosion.position = contact.contactPoint
        scene!.addChild(explosion)
        
        runAction(SKAction.playSoundFileNamed("playerHit.wav",
                                waitForCompletion: false))
    }
   
    private func initNodeGraph() {
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.darkGrayColor()
        label.fontSize = 40
        label.text = "v"
        label.zRotation = CGFloat(M_PI)
        label.name = "label"
        self.addChild(label)
    }
    
    private func initPhysicsBody() {
        let body = SKPhysicsBody(rectangleOfSize: CGSizeMake(20, 20))
        body.affectedByGravity = false
        body.categoryBitMask = PlayerCategory
        body.contactTestBitMask = EnemyCategory
        body.collisionBitMask = 0
        body.fieldBitMask = 0
        physicsBody = body
    }
}

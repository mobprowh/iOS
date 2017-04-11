//
//  StartScene.swift
//  TextShooter
//
//  Created by Kim Topley on 11/11/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.greenColor()
        
        let topLabel = SKLabelNode(fontNamed: "Courier")
        topLabel.text = "TextShooter"
        topLabel.fontColor = SKColor.blackColor()
        topLabel.fontSize = 48
        topLabel.position = CGPointMake(frame.size.width/2,
        frame.size.height * 0.7)
        addChild(topLabel)
        
        let bottomLabel = SKLabelNode(fontNamed: "Courier")
        bottomLabel.text = "Touch anywhere to start"
        bottomLabel.fontColor = SKColor.blackColor()
        bottomLabel.fontSize = 20
        bottomLabel.position = CGPointMake(frame.size.width/2,
        frame.size.height * 0.3)
        addChild(bottomLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let transition = SKTransition.doorwayWithDuration(1.0)
        let game = GameScene(size:frame.size)
        view!.presentScene(game, transition: transition)
        
        runAction(SKAction.playSoundFileNamed("gameStart.wav",
                                waitForCompletion: false))
    }
}

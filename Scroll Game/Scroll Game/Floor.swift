//
//  Floor.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/18/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class Floor: SKSpriteNode {
    public init(maxWidth: CGFloat) {
        let floorSize = CGSize(width: maxWidth * 2, height: Floor.DEFAULT_HEIGHT)
        let imageTexture = SKTexture(imageNamed: "Floor")
        super.init(texture: imageTexture, color: UIColor.clear, size: floorSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: floorSize)
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.position = CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var DEFAULT_HEIGHT = CGFloat(28)
    static var HEIGHT_BUFFER = CGFloat(2) + Floor.DEFAULT_HEIGHT
}

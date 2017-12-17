//
//  Block.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/18/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class Block: SKSpriteNode {
    /* Initialize a block object at a y around where it previously was and an x at the right edge of the screen */
    public init(prevLocation: CGFloat, maxHeight: CGFloat, maxWidth: CGFloat) {
        _maxHeight = maxHeight
        _maxWidth = maxWidth
        let blockSize = CGSize(width: Block.BLOCK_WIDTH * maxWidth, height: Block.BLOCK_HEIGHT * maxHeight)
        let imageTexture = SKTexture(imageNamed: "Platform")
        super.init(texture: imageTexture, color: UIColor.clear, size: blockSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
        
        let physicsBody = self.physicsBody
        physicsBody?.categoryBitMask = 1
        physicsBody?.linearDamping = 0
        physicsBody?.friction = 0
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 0
        physicsBody?.velocity = CGVector(dx: Block.VELOCITY, dy: 0.0)
        physicsBody?.affectedByGravity = false
        
        let currHeight: CGFloat = getRandomHeight(max: maxHeight, from: prevLocation)
        self.position = CGPoint(x: maxWidth + (blockSize.width / 2), y: currHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Get a random float +- maxHeight / 5 around the previous y */
    func getRandomHeight(max maxHeight: CGFloat, from prevHeight: CGFloat) -> CGFloat {
        var prev = prevHeight
        let diff = maxHeight / 5
        if prev - diff < Floor.DEFAULT_HEIGHT + self.size.height / 2 {
            prev = diff + self.size.height / 2 + Block.SAFETY_DELTA
        } else if prev + diff > maxHeight - self.size.height / 2{
            prev = maxHeight - diff - self.size.height / 2 - Block.SAFETY_DELTA
        }
        let change = arc4random_uniform(UInt32(2 * diff))
        return prev + CGFloat(change) - diff

    }
    
    func getNextBlock() -> Block? {
        if (!hasSpawnedNew) {
            hasSpawnedNew = true;
            return Block(prevLocation: self.position.y, maxHeight: _maxHeight, maxWidth: _maxWidth)
        }
        return nil
    }
    
    func hasSpawned() -> Bool {
        return hasSpawnedNew
    }
    
    
    var _maxHeight, _maxWidth: CGFloat
    var hasSpawnedNew: Bool = false;
    static var VELOCITY = -75.0
    static var BLOCK_WIDTH = CGFloat(0.15)
    static var BLOCK_HEIGHT = CGFloat(0.08)
    static var SAFETY_DELTA = CGFloat(10)
}

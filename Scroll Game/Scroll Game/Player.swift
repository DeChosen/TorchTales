//
//  Player.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/18/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode {
    public init(playerType: String, maxHeight: CGFloat, maxWidth: CGFloat) {
        _maxHeight = maxHeight
        _maxWidth = maxWidth
        _jumpVector = CGVector(dx: 0, dy: Player.DEFAULT_JUMP_AMOUNT * maxHeight)
        _walkRight = Player.walkRightAnimation()
        _walkLeft = Player.walkLeftAnimation()
        
        let imageTexture = SKTexture(imageNamed: playerType)
        let playerSize = CGSize(width: Player.PLAYER_WIDTH * maxWidth, height: Player.PLAYER_HEIGHT * maxHeight)
        super.init(texture: imageTexture, color: UIColor.clear, size: playerSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
        
        let physicsBody = self.physicsBody
        physicsBody?.categoryBitMask = 7
        physicsBody?.contactTestBitMask = 1
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        
        self.run(SKAction.repeatForever(_walkRight))
        self.position = Player.DEFAULT_STARTING_POSITION
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func recoverJump() {
        _canJump = true
    }
    
    func jump() {
        if (_canJump) {
            _canJump = false
            self.physicsBody?.applyImpulse(_jumpVector)
        }
    }
    
    func move(velocity: CGFloat) {
        if !isMoving {
            isMoving = true
            self.physicsBody?.velocity = CGVector(dx: velocity, dy: (self.physicsBody?.velocity.dy)!)
        }
    }
    
    func moveLeft() {
        if _isMovingRight {
            self.run(_walkLeft)
            _isMovingRight = false
        }
        move(velocity: CGFloat(-120))
    }
    
    func moveRight() {
        if !_isMovingRight {
            self.run(_walkRight)
            _isMovingRight = true
        }
        move(velocity: CGFloat(120))
    }
    
    func endMove() {
        isMoving = false
        if !_isMovingRight {
            self.run(_walkRight)
            _isMovingRight = true
        }
        self.physicsBody?.velocity = CGVector(dx: 0, dy: (self.physicsBody?.velocity.dy)!)
    }
    
    func isPlayerMoving() -> Bool {
        return isMoving
    }
    
    static func walkRightAnimation() -> SKAction {
        let textureAtlas = SKTextureAtlas(named: "WalkRight")
        let walk1 = textureAtlas.textureNamed("walk_right_1")
        let walk2 = textureAtlas.textureNamed("walk_right_2")
        let textures = [walk1, walk2]
        return SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.2))
    }
    
    static func walkLeftAnimation() -> SKAction {
        let textureAtlas = SKTextureAtlas(named: "WalkLeft")
        let walk1 = textureAtlas.textureNamed("walk_left_1")
        let walk2 = textureAtlas.textureNamed("walk_left_2")
        let textures = [walk1, walk2]
        return SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.2))
    }
    
    

    var _jumpVector: CGVector
    var _canJump = true, isMoving = false
    var _maxHeight, _maxWidth: CGFloat
    var _walkLeft, _walkRight: SKAction
    var _isMovingRight = true
    static var PLAYER_WIDTH = CGFloat(0.05),
    PLAYER_HEIGHT = CGFloat(0.2),
    DEFAULT_JUMP_AMOUNT = CGFloat(0.13)
    static var DEFAULT_STARTING_POSITION = CGPoint(x: 300, y: 30)
}

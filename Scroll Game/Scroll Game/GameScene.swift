//
//  GameScene.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/18/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    public init(size: CGSize, callback: @escaping (_ name: String, _ scene: SKScene?) -> ()) {
        _player = Player(playerType: "Default", maxHeight: size.height, maxWidth: size.width)
        _leftArrow = ArrowKey(size, "LeftArrow")
        _rightArrow = ArrowKey(size, "RightArrow")
        _scoreDisplay = ScoreDisplay(size: size)
        _pauseButton = GameScene.makePauseButton(screenSize: size)
        _loadSceneCallback = callback
        super.init(size: size)
        
        self.isUserInteractionEnabled = true
        self.physicsWorld.gravity = GameScene.DEFAULT_GRAVITY
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = UIColor.lightGray
        
        let width = self.size.width
        let height = self.size.height
        self.addChild(Background(size: self.size, name: "GameBackground"))
        self.addChild(Floor(maxWidth: width))
        self.addChild(_player)
        self.addChild(_leftArrow)
        self.addChild(_rightArrow)
        self.addChild(_scoreDisplay)
        self.addChild(_pauseButton)
        self.addChild(Block(prevLocation: height / 2, maxHeight: height, maxWidth: width))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchedNode = GameScene.viewLocationToSceneNodes(viewLocation: touch.location(in: self), scene: self)
            
            if touchedNode.contains(_leftArrow) {
                _player.moveLeft()
            } else if touchedNode.contains(_rightArrow) {
                _player.moveRight()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchedNode = GameScene.viewLocationToSceneNodes(viewLocation: touch.location(in: self), scene: self)
            let prevNode = GameScene.viewLocationToSceneNodes(viewLocation: touch.previousLocation(in: self), scene: self)
            
            if (prevNode.contains(_leftArrow) || prevNode.contains(_rightArrow)) && !touchedNode.contains(_leftArrow) && !touchedNode.contains(_rightArrow) {
                _player.endMove()
                return
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchedNode = GameScene.viewLocationToSceneNodes(viewLocation: touch.location(in: self), scene: self)
            
            if touchedNode.contains(_pauseButton) {
                pauseGame()
                return
            }
            
            if touchedNode.contains(_leftArrow) || touchedNode.contains(_rightArrow) && _player.isPlayerMoving() {
                _player.endMove()
                return
            }
            
            _player.jump()
        }
    }
    
    static func viewLocationToSceneNodes(viewLocation: CGPoint, scene: SKScene) -> [SKNode] {
        let sceneTouchPoint = ViewController.flipPointHeight(point: scene.convertPoint(toView: viewLocation), size: scene.size)
        return scene.nodes(at: sceneTouchPoint)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        _scoreDisplay.addPoint()
        if let prevBlock = shouldSpawnNewBlock() {
            self.addChild(prevBlock.getNextBlock()!)
        }
        
        if let delBlock = shouldDeleteBlock() {
            self.removeChildren(in: [delBlock])
        }
        
        if playerOutOfBounds() {
            gameOver()
        }
    }
    
    
    func shouldSpawnNewBlock() -> Block? {
        let rayStart = CGPoint(x: GameScene.SPAWN_THRESHOLD * self.size.width, y: self.size.height)
        let rayEnd = CGPoint(x: GameScene.SPAWN_THRESHOLD * self.size.width, y: 0)
        
        let body = self.physicsWorld.body(alongRayStart: rayStart, end: rayEnd)
        
        if (body?.categoryBitMask == 1) {
            if let prevBlock = body {
                let prev: Block = prevBlock.node as! Block
                if (!prev.hasSpawned()) {
                    return prev
                }
            }
        }
        return nil
    }
    
    
    func shouldDeleteBlock() -> Block? {
        let rayStart = CGPoint(x: GameScene.DELETE_THRESHOLD, y: self.size.height)
        let rayEnd = CGPoint(x: GameScene.DELETE_THRESHOLD, y: 0)
        
        let body = self.physicsWorld.body(alongRayStart: rayStart, end: rayEnd)
        
        if (body?.categoryBitMask == 1) {
            return body?.node as? Block
        }
        return nil
    }
    
    
    func playerOutOfBounds() -> Bool {
        return _player.position.x < _player.size.width / 2 || _player.position.x > self.size.width - _player.size.width / 2
    }
    
    func gameOver() {
        _loadSceneCallback("GameOverScene", GameOverScene(size: self.size, callback: _loadSceneCallback, score: _scoreDisplay.score()))
    }
    
    func pauseGame() {
        self.isPaused = true
        _loadSceneCallback("PauseScene", PauseScene(size: self.size, gameScene: self, callback: _loadSceneCallback))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let first = contact.bodyA
        let second = contact.bodyB
        
        if (first.categoryBitMask == 7 || second.categoryBitMask == 7) {
            _player.recoverJump()
        }
    }
    
    static func makePauseButton(screenSize: CGSize) -> Button {
        let buttonSize = CGSize(width: screenSize.width * 2 / 23, height: screenSize.height / 8)
        let position = CGPoint(x: buttonSize.width / 2, y: screenSize.height - buttonSize.height / 2)
        return Button(buttonImageName: "PauseButton", size: buttonSize, name: "Pause", position: position)
    }
    
    var _player: Player
    var _leftArrow, _rightArrow: ArrowKey
    var _scoreDisplay: ScoreDisplay
    var _pauseButton: Button
    var _loadSceneCallback: (_ name: String, _ scene: SKScene?) -> ()
    static var DEFAULT_GRAVITY = CGVector(dx: 0.0, dy: -7.0)
    static var SPAWN_THRESHOLD = CGFloat(0.67)
    static var DELETE_THRESHOLD = CGFloat(-100)
}

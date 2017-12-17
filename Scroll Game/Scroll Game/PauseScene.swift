//
//  PauseScene.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/20/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class PauseScene: SKScene {
    public init(size: CGSize, gameScene: GameScene, callback: @escaping (_ name: String, _ scene: SKScene?) -> ()) {
        _gameScene = gameScene
        _loadSceneCallback = callback
        _exitButton = PauseScene.loadExitButton(frame: size)
        _restartButton = PauseScene.loadRestartButton(frame: size)
        _muteButton = PauseScene.loadMuteButton(frame: size)
        
        super.init(size: size)
        
        self.addChild(Background(size: self.size, name: "PauseBackground"))
        self.addChild(_exitButton)
        self.addChild(_restartButton)
        self.addChild(_muteButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchedNode = GameScene.viewLocationToSceneNodes(viewLocation: touch.location(in: self), scene: self)
        
        if touchedNode.contains(_exitButton) {
            _loadSceneCallback("MainMenuScene", nil)
        } else if touchedNode.contains(_restartButton) {
            _loadSceneCallback("GameScene", nil)
        } else if touchedNode.contains(_muteButton) {
            return
//            print("Mute")
        } else {
            unpause()
        }
        
    }
    
    func unpause() {
        _loadSceneCallback("GameScene", _gameScene)
        _gameScene.isPaused = false
    }
    
    static func loadExitButton(frame: CGSize) -> Button {
        let size = CGSize(width: frame.width * 105 / 675, height: frame.height * 70 / 375)
        let position = CGPoint(x: frame.width * 458 / 675, y: frame.height * 51 / 375)
        return Button(size: size, name: "Exit", position: position)
    }
    
    static func loadRestartButton(frame: CGSize) -> Button {
        let size = CGSize(width: frame.width * 105 / 675, height: frame.height * 70 / 375)
        let position = CGPoint(x: frame.width * 215 / 675, y: frame.height * 51 / 375)
        return Button(size: size, name: "Retry", position: position)
    }
    
    static func loadMuteButton(frame: CGSize) -> Button {
        let size = CGSize(width: frame.width * 105 / 675, height: frame.height * 70 / 375)
        let position = CGPoint(x: frame.width * 335 / 675, y: frame.height * 51 / 375)
        return Button(size: size, name: "Mute", position: position)
    }
    
    var _gameScene: GameScene
    var _loadSceneCallback: (_ name: String, _ scene: SKScene?) -> ()
    var _exitButton, _restartButton, _muteButton: Button
}

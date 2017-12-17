//
//  MainMenuScene.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/18/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuScene: SKScene {
    init(size: CGSize, highscore: Int?) {
        _startButton = MainMenuScene.makeStartButton(screenSize: size)
        _optionButton = OptionButton(size)
        super.init(size: size)
        
        self.addChild(Background(size: size, name: "MainMenuBackground"))
        self.addChild(_startButton)
        self.addChild(_optionButton)
        if highscore != nil {
            _highscoreLabel = SKLabelNode(text: "High Score: \(highscore!)")
            _highscoreLabel!.position = CGPoint(x: size.width - _highscoreLabel!.frame.size.width / 2 + 20, y: size.height - _highscoreLabel!.frame.size.height / 2 - 10)
            _highscoreLabel!.fontSize = 20
            _highscoreLabel!.fontColor = .black
            _highscoreLabel!.fontName = "ArialMT"
            self.addChild(_highscoreLabel!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newHighScore(highscore: Int?) {
        if highscore != nil {
            _highscoreLabel?.text = "High Score: \(highscore!)"
        }
    }
    
    static func makeStartButton(screenSize: CGSize) -> Button {
        let buttonSize = CGSize(width: screenSize.width * 18 / 95, height: screenSize.height * 4 / 25)
        let position = CGPoint(x: screenSize.width * 66 / 133, y: screenSize.height * 41 / 75)
        return Button(size: buttonSize, name: "Start", position: position)
    }
    
    var _startButton: Button
    var _optionButton: OptionButton
    var _highscoreLabel: SKLabelNode?
}

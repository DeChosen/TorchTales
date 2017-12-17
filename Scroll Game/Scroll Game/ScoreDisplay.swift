//
//  ScoreDisplay.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/19/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class ScoreDisplay: SKSpriteNode {

    public init(size: CGSize) {
        let displaySize = CGSize(width: size.width * 100 / 667, height: size.height * 4 / 15)
        let imageTexture = SKTexture(imageNamed: "Scoreboard")
        
        _scoreLabel = SKLabelNode(text: String(describing: _score))
        _scoreLabel.position = CGPoint(x: displaySize.width * 97 / 200, y: displaySize.height / 2)
        _scoreLabel.fontSize = 10
        _scoreLabel.fontName = "Arial-MT"
        
        super.init(texture: imageTexture, color: UIColor.clear, size: displaySize)
        self.anchorPoint = CGPoint.zero
        self.position = CGPoint(x: size.width - displaySize.width, y: size.height - displaySize.height)
        self.addChild(_scoreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPoint() {
        _score += 1
        _scoreLabel.text = String(_score / ScoreDisplay.SCORE_DIVIDER)
    }
    
    func score() -> Int {
        return _score / ScoreDisplay.SCORE_DIVIDER
    }

    var _scoreLabel: SKLabelNode
    var _score: Int = 0
    static var SCORE_DIVIDER: Int = 8
}

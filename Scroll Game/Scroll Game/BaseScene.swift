//
//  BaseScene.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/18/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class BaseScene: SKScene {
    public init(size: CGSize, view: SKView) {
        _view = view
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeScene(to scene: SKScene, with transition: SKTransition?) {
        if transition != nil {
            _view.presentScene(scene, transition: transition!)
            return
        }
        _view.presentScene(scene)
    }
    
    
    var _view: SKView
}

//
//  Background.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/18/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class Background: SKSpriteNode {
    public init(size: CGSize, name: String) {
        super.init(texture: SKTexture(imageNamed: name), color: UIColor.clear, size: size)
        self.anchorPoint = CGPoint.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

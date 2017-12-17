//
//  ButtonBase.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/18/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class Button: SKSpriteNode {
    public init(buttonImageName: String, size: CGSize, name: String, position: CGPoint) {
        let imageTexture = SKTexture(imageNamed: buttonImageName)
        super.init(texture: imageTexture, color: UIColor.clear, size: size)
        self.name = name
        self.position = position
    }
    
    public init(size: CGSize, name: String, position: CGPoint) {
        super.init(texture: nil, color: UIColor.clear, size: size)
        self.name = name
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

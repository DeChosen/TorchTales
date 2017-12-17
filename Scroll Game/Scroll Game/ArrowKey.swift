//
//  ArrowKey.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/19/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit

class ArrowKey: SKSpriteNode {
    public init(_ size: CGSize, _ arrowDirection: String) {
        let arrowSize = CGSize(width: size.width * 100 / 667, height: size.height / 4)
        super.init(texture: SKTexture(imageNamed: arrowDirection), color: UIColor.clear, size: arrowSize)
        self.anchorPoint = CGPoint.zero
        if arrowDirection == "LeftArrow" {
            self.position = CGPoint(x: size.width * 40 / 667, y: size.height * 2 / 25)
        } else {
            self.position = CGPoint(x: size.width * 140 / 667, y: size.height * 2 / 25)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    static func getArrowPoints(_ arrowStart: CGPoint, _ direction: String, _ sceneSize: CGSize) -> [CGPoint] {
//        if direction.caseInsensitiveCompare("left") == ComparisonResult.orderedSame {
//            return [arrowStart,
//                    CGPoint(x: arrowStart.x, y: arrowStart.y + sceneSize.height * )]
//        }
//    }
}

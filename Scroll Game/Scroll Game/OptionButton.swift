//
//  OptionButton.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/19/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit

class OptionButton: Button {
    public init(_ screenSize: CGSize) {
        let buttonSize = CGSize(width: screenSize.width * 30 / 133, height: screenSize.height * 103 / 750)
        let position = CGPoint(x: screenSize.width * 66 / 133, y: screenSize.height * 481 / 1500)
        super.init(size: buttonSize, name: "Option", position: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

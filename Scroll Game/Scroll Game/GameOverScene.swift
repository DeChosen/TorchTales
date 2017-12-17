//
//  GameOverScene.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/19/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class GameOverScene: SKScene {
    public init(size: CGSize, callback: @escaping (_ name: String, _ scene: SKScene?) -> (), score: Int) {
        _loadSceneCallback = callback
        _exitButton = GameOverScene.makeExitButton(screenSize: size)
        _restartButton = GameOverScene.makeRestartButton(screenSize: size)
        _score = score
        super.init(size: size)
        
        self.isUserInteractionEnabled = true
        self.addChild(Background(size: size, name: "GameOverBackground"))
        self.addChild(_exitButton)
        self.addChild(_restartButton)
        
        saveHighScore()
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
        }
    }
    
    func saveHighScore() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Score", in: managedContext)!
        let score = NSManagedObject(entity: entity, insertInto: managedContext)
       
        score.setValue(_score, forKeyPath: "score")
        score.setValue(Date().timeIntervalSince1970, forKeyPath: "date")
        
        try? managedContext.save()
    }
    
    func clearHighScore() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Score")
        
        if let results = try? managedContext.fetch(fetchRequest) {
            for res in results {
                managedContext.delete(res)
            }
            try? managedContext.save()
        }
    }
    
    static func makeExitButton(screenSize: CGSize) -> Button {
        let buttonSize = CGSize(width: screenSize.width * 100 / 667, height: screenSize.height * 14 / 75)
        let position = CGPoint(x: screenSize.width * 450 / 667, y: screenSize.height * 11 / 75)
        return Button(size: buttonSize, name: "Exit", position: position)
    }
    
    static func makeRestartButton(screenSize: CGSize) -> Button {
        let buttonSize = CGSize(width: screenSize.width * 105 / 667, height: screenSize.height * 14 / 75)
        let position = CGPoint(x: screenSize.width * 407 / 1334, y: screenSize.height * 11 / 75)
        return Button(size: buttonSize, name: "Restart", position: position)
    }
    
    var _loadSceneCallback: (_ name: String, _ scene: SKScene?) -> ()
    var _score: Int
    var _exitButton: Button
    var _restartButton: Button
}

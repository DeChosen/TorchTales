//
//  ViewController.swift
//  Scroll Game
//
//  Created by Matt Lin on 11/16/17.
//  Copyright © 2017 Matt Lin. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view = SKView()
        skView.showsFPS = true
        skView.isMultipleTouchEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let screenSize = UIScreen.main.bounds
        _sceneSize = CGSize(width: screenSize.width, height: screenSize.height)
        loadMainMenuScene()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let sceneWrapped = skView.scene
        if (sceneWrapped == nil) {
            return
        }
        let scene = sceneWrapped!
        
        let viewTouchLocation = touch.location(in: scene)
        let sceneTouchPoint = ViewController.flipPointHeight(point: scene.convertPoint(fromView: viewTouchLocation), size: scene.size)
        let touchedNode = scene.nodes(at: sceneTouchPoint)
        
        if let mainMenuScene = scene as? MainMenuScene {
            if touchedNode.contains(mainMenuScene._startButton) {
                loadGameScene(nil)
            }
//            if touchedNode.contains(mainMenuScene._optionButton) {
//                getHighScore()
//            }
        }
    }
    
    
    func getHighScore() -> Int? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Score")
        
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1
        
        if let results = try? managedContext.fetch(fetchRequest) {
            if let res = results.first {
                return res.value(forKey: "score") as? Int
            }
        }
        return nil
//        do {
//            let results = try managedContext.fetch(fetchRequest)
//            if results.count == 0 {
//                NSLog("No High Scores saved")
//            }
//
//            for (ind, val) in results.enumerated() {
//                let score = val.value(forKey: "score")
//                let unixTime = val.value(forKey: "date") as! TimeInterval
//                let date = Date(timeIntervalSince1970: unixTime)
//                let dateFormatter = DateFormatter()
//                dateFormatter.timeZone = TimeZone(identifier: "America/Berkeley")
//                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
//
//                NSLog("High Score \(ind): \(String(describing: score!)) \(dateFormatter.string(from: date))")
//            }
//        } catch let error as NSError {
//            NSLog("Could not fetch. \(error), \(error.userInfo)")
//        }
        
    }
    
    
    static func flipPointHeight(point: CGPoint, size: CGSize) -> CGPoint {
        let newHeight = size.height - point.y
        return CGPoint(x: point.x, y: newHeight)
    }
    
    
    func loadSceneFromName(_ name: String, _ scene: SKScene?) {
        switch(name) {
            case "GameScene":
                loadGameScene(scene)
            case "GameOverScene":
                loadGameOverScene(scene)
            case "PauseScene":
                loadPauseScreen(scene!)
            case "OptionScene":
                loadOptionScene()
        default:
            loadMainMenuScene()
        }
    }
    
    
    func loadMainMenuScene() {
        if scenes["MainMenuScene"] == nil {
            scenes["MainMenuScene"] = MainMenuScene(size: _sceneSize, highscore: getHighScore())
        } else {
            (scenes["MainMenuScene"] as! MainMenuScene).newHighScore(highscore: getHighScore())
        }
        skView.presentScene(scenes["MainMenuScene"]!, transition: ViewController.DEFAULT_FADE_TRANSITION)

    }
    
    
    func loadGameScene(_ scene: SKScene?) {
        var gameScene: SKScene
        if scene != nil {
            gameScene = scene!
        } else {
            gameScene = GameScene(size: _sceneSize, callback: loadSceneFromName)
        }
        scenes["GameScene"] = gameScene
        skView.presentScene(gameScene, transition: ViewController.DEFAULT_FADE_TRANSITION)
    }
    
    
    func loadGameOverScene(_ scene: SKScene?) {
        var gameOverScene: SKScene
        if scene != nil {
            gameOverScene = scene!
            scenes["GameOverScene"] = gameOverScene
        } else if scenes["GameOverScene"] == nil {
            gameOverScene = GameOverScene(size: _sceneSize, callback: loadSceneFromName, score: 0)
            scenes["GameOverScene"] = gameOverScene
        } else {
            gameOverScene = scenes["GameOverScene"]!
        }
        
        skView.presentScene(gameOverScene, transition: ViewController.DEFAULT_FADE_TRANSITION)
    }
    
    func loadPauseScreen(_ scene: SKScene) {
        scenes["PauseScene"] = scene
        skView.presentScene(scene)
    }
    
    
    func loadOptionScene() {
        let optionScene = SKScene()
        skView.presentScene(optionScene, transition: ViewController.DEFAULT_FADE_TRANSITION)
    }
    
    
    var skView: SKView {
        return view as! SKView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var _sceneSize: CGSize = CGSize(width: 667, height: 375)
    var scenes: [String: SKScene] = [:]
    static var DEFAULT_FADE_TRANSITION = SKTransition.fade(withDuration: 0.5)
}



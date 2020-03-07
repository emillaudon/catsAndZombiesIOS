//
//  ViewController.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-05.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet var gameOverLabels: [UILabel]!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var catCountLabel: UILabel!
    
    @IBOutlet var backGroundView: UIView!
    @IBOutlet var backgroundLayers: [UIImageView]!

    @IBOutlet var gestureRecognizers: [UISwipeGestureRecognizer]!
    
    @IBOutlet weak var fadeView: UIView!
    
    @IBOutlet weak var catView: UIView!
    
    @IBOutlet weak var touchView: UIView!
    let screenSize:CGRect = UIScreen.main.bounds
    
    var map: Map!
    var cats = [Cat]()
    var zombies = [Zombie]()
    
    var playerX = 0
    var playerY = 0
    
    var catsCaught = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = Map()
        
        for index in 1...20 {
            cats.append(Cat())
        }
        
        zombies.append(Zombie())
        zombies.append(Zombie())
        zombies.append(Zombie(x: 0, y: 1))
        
        for cat in cats {
            print(cat.position.x)
            print(cat.position.y)
        }
        
        let cat1 = Cat()
        cat1.position.x = 0
        cat1.position.y = 0
        cats.append(cat1)
        updatePositionLabel()
        
        print(map.coordinates[1][2])
        
        updateLayers(using: map)
    }
    
    
    func updateLayers(using map: Map) {
        checkForCat()
        var currentLayer = 0
        
        for layer in backgroundLayers {
            layer.frame.origin.x = getXPosition(of: currentLayer, using: map)
            
            currentLayer += 1
        }
    }
    
    func getXPosition(of layer: Int, using map: Map) -> CGFloat {
        let xPositionOfCurrentLayer = map.coordinates[playerX][playerY][layer]
        return CGFloat(xPositionOfCurrentLayer)
    }
    
    func checkForCat() {
        removeCatsFromView()
        for cat in cats {
            if cat.position.x == playerX && cat.position.y == playerY {
                drawCat(cat: cat)
            }
        }
    }
    
    func checkForZombie() {
        for zombie in zombies {
            if zombie.position.x == playerX && zombie.position.y == playerY {
                print("zombie same spot")
                gameOver()
                return
            }
        }
    }
    
    func checkForCatsInSameCoordinates(cats: [Cat]) {
        var cat1: Cat
        var cat2: Cat
        for cat in cats {
            cat1 = cat
            for cat in cats {
                cat2 = cat
                if cat1.position == cat2.position && cat1 != cat2 {
                    repeat {
                        cat.changePosition()
                        print("cats at same pos. moved.")
                    } while cat1.position == cat2.position && cat1 != cat2
                    
                }
            }
        }
    }
    
    func updateCatCountLabel() {
        catCountLabel.text = "Cats Caught: \(catsCaught)"
    }
    
    func updatePositionLabel() {
        positionLabel.text = "x: \(playerX) y: \(playerY)"
    }
    
    func moveToNewPosition() {
        for cat in cats {
            cat.addMoveCount(to: cat)
        }
        for zombie in zombies {
            zombie.addPlayerMoveToZombie(playerX: playerX, playerY: playerY)
        }
        checkForCatsInSameCoordinates(cats: cats)
        fadeScreen {
            self.checkForZombie()
        }
        
    }
    
    func fadeScreen(completion:@escaping() -> ()) {
        for recognizer in gestureRecognizers {
            recognizer.isEnabled = false
        }
        self.backGroundView.bringSubviewToFront(fadeView)
        UIView.animate(withDuration: 1.0, animations: {
            self.fadeView.alpha = 1.0
        }) { (comp) in
            self.updateLayers(using: self.map)
            UIView.animate(withDuration: 1.0, animations: {
                self.fadeView.alpha = 0.0
            }) { (comp) in
                for recognizer in self.gestureRecognizers {
                    recognizer.isEnabled = true
                }
                self.backGroundView.sendSubviewToBack(self.fadeView)
                completion()
            }
        }
    }
    
    func drawCat(cat: Cat) {
        let catImage = cat.sprite
        
        let catButton = UIButton()
        
        catButton.setBackgroundImage(catImage, for: .normal)
        
        catButton.frame = CGRect(x: 10, y: 451, width: 130, height: 130)
        catButton.addTarget(self, action:#selector(self.catTapped(_:)), for: .touchUpInside)
        
        touchView.addSubview(catButton)
        
        catButton.isUserInteractionEnabled = true
        animateCat(cat: catButton)
    }
    
    func animateCat(cat: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            cat.frame.origin = CGPoint(x: cat.frame.origin.x, y: cat.frame.origin.y + 25)
        }, completion: nil)
    }
    
    func removeCatsFromView() {
        for subView in touchView.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func removeCatFromGame() {
        removeCatsFromView()
        var index = 0
        for cat in cats {
            if cat.position.x == playerX && cat.position.y == playerY {
                cats.remove(at: index)
                print("removed cat")
            }
            index += 1
        }
    }
    
    func gameOver() {
        backGroundView.bringSubviewToFront(fadeView)
        let sceneView = SKView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.size.height ))
        let scene = SKScene()
        scene.scaleMode = SKSceneScaleMode.resizeFill
        
        sceneView.allowsTransparency = true
        sceneView.backgroundColor = .clear
        scene.backgroundColor = .clear
        // Do any other scene setup here
        view.addSubview(sceneView)
        sceneView.presentScene(scene)
        //view.bringSubviewToFront(touchView)
        buildWalkingZombie(zombies[0], in: scene)
        zombies[0].position = Point(x: 0, y: 1)
    }
    
    func showGameOverTextAndButton() {
        backGroundView.bringSubviewToFront(touchView)
        touchView.alpha = 1.0
        UIView.animate(withDuration: 0.6, animations: {
            self.gameOverLabels[0].alpha = 1.0
        }) { (completion) in
            UIView.animate(withDuration: 0.6, animations: {
                self.gameOverLabels[1].alpha = 1.0
            }) { (completion) in
//                self.backGroundView.sendSubviewToBack(self.touchView)
//                let tempBlackView = UIView(frame: self.screenSize)
//                tempBlackView.backgroundColor = .black
//                self.backGroundView.addSubview(tempBlackView)
//                self.fadeView.backgroundColor = .clear
//                self.backGroundView.bringSubviewToFront(self.fadeView)
                
                UIView.animate(withDuration: 0.6, animations: {
                    self.gameOverLabels[2].alpha = 1.0
                }) { (completion) in
                    print(self.gameOverLabels[1].alpha)
                   self.restartButton.isHidden = false
                   self.restartButton.alpha = 1.0
                }
            }
        }
    }

    
    func buildWalkingZombie(_ zombie: Zombie, in SKScene: SKScene)  {
        
        let zombieWalkingAtlas = zombie.walkingAtlas
        var walkFrames: [SKTexture] = []
        
        let numberOfImages = zombieWalkingAtlas.textureNames.count
        
        for i in 1...numberOfImages {
            let zombieTextureName = "Walk\(i)"
            walkFrames.append(zombieWalkingAtlas.textureNamed(zombieTextureName))
        }
        let firstFrameTexture = walkFrames[0]
        let zombie = SKSpriteNode(texture: firstFrameTexture)
        zombie.position = CGPoint(x: -50, y: 155)
        zombie.scale(to: CGSize(width: 100, height:188))
        //zombie.xScale = -1
        
        SKScene.addChild(zombie)
        print("child added")
        animateZombieAndFadeScreen(zombie, frames: walkFrames)
    }
    
    func animateZombieAndFadeScreen(_ zombie: SKSpriteNode, frames: [SKTexture]) {
        zombie.zPosition = 1000
        
        zombie.run(SKAction.repeatForever(
            SKAction.animate(with: frames,
                             timePerFrame: 0.12, resize: true,
                             restore: true)))
        
        
        zombie.run(SKAction.moveTo(x: 200, duration: 5)) {
            zombie.run(SKAction.scale(by: 2, duration: 10))
            UIView.animate(withDuration: 3.0, animations: {
                self.fadeView.alpha = 1.0
            }) { (completion) in
                self.showGameOverTextAndButton()
            }
        }
    }
    @objc func catTapped(_ sender: UIButton?) {
        print("tapped")
        catsCaught += 1
        updateCatCountLabel()
        removeCatFromGame()
    }

    //swipe functions
    @IBAction func upGesture(_ sender: Any) {
        if playerY > 0 {
            playerY -= 1
            updatePositionLabel()
            moveToNewPosition()
        }
    }
    
    @IBAction func downGesture(_ sender: Any) {
        if playerY < 6 {
            playerY += 1
            updatePositionLabel()
            moveToNewPosition()
        }
    }
    
    @IBAction func rightGesture(_ sender: Any) {
        if playerX > 0 {
            playerX -= 1
            updatePositionLabel()
            moveToNewPosition()
        }
    }
    
    @IBAction func leftGesture(_ sender: Any) {
        if playerX < 6 {
            playerX += 1
            updatePositionLabel()
            moveToNewPosition()
        }
    }
    
    
}


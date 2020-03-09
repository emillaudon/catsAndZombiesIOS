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

class ViewController: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var mapCollectionView: UICollectionView!
    
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
    var catsRequiredToWin = 3
    
    var observableSquares = 2
    

    override func viewDidLoad() {
        setUpCollectionViewCells()
        super.viewDidLoad()
        view.bringSubviewToFront(fadeView)
        fadeView.alpha = 1.0
        
        startNewGame()
        
    }
    
    func startNewGame() {
        map = Map()
        
        addCats(3)
        cats[0].position.x = 2
        cats[0].position.y = 0
        
        
        addZombies(1)
        
        setStartingPositionAndScore()
        
        updatePositionLabel()
        updateCatCountLabel()
        
        mapCollectionView.reloadData()
        
        updateLayers(using: map)
        
        fadeInToNewGame()
        print(cats.count)
        
    }
    
    func addCats(_ amount: Int) {
        catsRequiredToWin = amount
        cats.removeAll()
        for _ in 1...amount {
            cats.append(Cat())
        }
    }
    
    func addZombies(_ amount: Int) {
        zombies.removeAll()
        for _ in 1...amount {
            zombies.append(Zombie())
        }
    }
    
    func setStartingPositionAndScore() {
        playerX = 0
        playerY = 0
        
        catsCaught = 0
    }
    
    func fadeInToNewGame() {
        UIView.animate(withDuration: 0.5, animations: {
            self.fadeView.alpha = 0.0
        }) { (completion) in
            self.view.sendSubviewToBack(self.fadeView)
            self.view.bringSubviewToFront(self.touchView)
            self.touchView.isUserInteractionEnabled = true
        }
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
    
    func checkForZombiessInNearbyCoordinates() -> [Zombie] {
        var nearbyZombies = [Zombie]()
        let currentPlayerIndexPathRow = getIndexPathRowFromCoordinates(x: playerX, y: playerY)
        for zombie in zombies {
            if compareCoordinatesToPlayer(position: zombie.position) {
                nearbyZombies.append(zombie)
            }
        }
        
        return nearbyZombies
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
    
    func checkForCatsInNearbyCoordinates() -> [Cat]{
        var nearbyCats = [Cat]()
        let currentPlayerIndexPathRow = getIndexPathRowFromCoordinates(x: playerX, y: playerY)
        for cat in cats {
            if compareCoordinatesToPlayer(position: cat.position) {
                nearbyCats.append(cat)
            }
        }
        
        return nearbyCats
    }
    
    func compareCoordinatesToPlayer(position: Point) -> Bool{
        if position.x >= playerX - observableSquares && position.x <= playerX + observableSquares && position.y >= playerY - observableSquares && position.y <= playerY {
             return true
        } else {
            return false
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
            self.mapCollectionView.reloadData()
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
        
        let sceneView = SKView(frame: CGRect(x: 0, y: screenSize.height/2, width: screenSize.width, height: screenSize.size.height/2 ))
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
    }
    
    func checkIfGameIsWon() {
        if catsCaught == catsRequiredToWin {
            print("win")
            touchView.isUserInteractionEnabled = false
            view.bringSubviewToFront(fadeView)
            gameOverLabels[2].text = "You Win!"
            
            UIView.animate(withDuration: 1, animations: {
                self.fadeView.alpha = 1.0
                self.gameOverLabels[2].alpha = 1.0
            }) { (complete) in
                UIView.animate(withDuration: 0.6) {
                    self.restartButton.alpha = 1.0
                    self.restartButton.isHidden = false
                    self.restartButton.isUserInteractionEnabled = true
                    self.restartButton.isEnabled = true
                }
            }
        }
    }
    
    
    func showGameOverTextAndButton() {
        //backGroundView.bringSubviewToFront(touchView)
        backGroundView.bringSubviewToFront(self.restartButton)
        UIView.animate(withDuration: 0.6, animations: {
            self.gameOverLabels[0].alpha = 1.0
        }) { (completion) in
            UIView.animate(withDuration: 0.8, animations: {
                self.gameOverLabels[1].alpha = 1.0
            }) { (completion) in
                UIView.animate(withDuration: 0.8, animations: {
                    self.gameOverLabels[2].alpha = 1.0
                }) { (completion) in
                    UIView.animate(withDuration: 0.8) {
                        self.restartButton.isHidden = false
                        self.restartButton.alpha = 1.0
                        self.restartButton.isEnabled = true
                    }
                   
                }
            }
        }
    }
    
    func hideGameOverTextAndButton (completion:@escaping() -> ()) {
        UIView.animate(withDuration: 0.5, animations: {
            for label in self.gameOverLabels {
                label.alpha = 0
            }
            self.restartButton.alpha = 0
            self.restartButton.isEnabled = false
        }) { (completed) in
            completion()
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
    
    func getIndexPathRowFromCoordinates(x: Int, y: Int) -> Int {
        
        let baseRowValue = 42
        
        let currentRowValue = 42 - (7 * y) + x
        
        return currentRowValue
    }
    
    
    @objc func catTapped(_ sender: UIButton?) {
        print("tapped")
        catsCaught += 1
        updateCatCountLabel()
        removeCatFromGame()
        checkIfGameIsWon()
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
    
    @IBAction func restartButtonTapped(_ sender: Any) {
        hideGameOverTextAndButton {
            self.startNewGame()
        }
        gameOverLabels[2].text = "Game Over"
        
        for subView in view.subviews {
            if subView is SKView {
                UIView.animate(withDuration: 0.3, animations: {
                    subView.alpha = 0.0
                }) { (completion) in
                    subView.removeFromSuperview()
                }
            }
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setUpCollectionViewCells() {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let padding: CGFloat = 0
        
        let itemWidth = mapCollectionView.frame.width/7 - padding
        let itemHeight = mapCollectionView.frame.height/7 - padding
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        mapCollectionView.collectionViewLayout = layout
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as! UICollectionViewCell
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        cell.backgroundView?.removeFromSuperview()
    
        print("coordinate: \(getIndexPathRowFromCoordinates(x: playerX, y: playerY))")
        
        print(indexPath.row)
        let nearbyZombies = checkForZombiessInNearbyCoordinates()
        
        for zombie in nearbyZombies {
            if indexPath.row == getIndexPathRowFromCoordinates(x: zombie.position.x, y: zombie.position.y) {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width - 0.5, height: cell.frame.height - 0.5))
                
                let image = UIImage(named: "Walk1")
                imageView.image = image
                cell.backgroundView = UIView()
                cell.backgroundView!.addSubview(imageView)
                print("put zombie image")
            }
        }
        
        let nearbyCats = checkForCatsInNearbyCoordinates()
        for cat in nearbyCats {
            if indexPath.row == getIndexPathRowFromCoordinates(x: cat.position.x, y: cat.position.y) {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width - 0.5, height: cell.frame.height - 0.5))
                
                let image = cat.sprite
                imageView.image = image
                cell.backgroundView = UIView()
                cell.backgroundView!.addSubview(imageView)
                print("put cat image")
            }
        }
        
        if indexPath.row == getIndexPathRowFromCoordinates(x: playerX, y: playerY){
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width - 0.5, height: cell.frame.height - 0.5))
            
            let image = UIImage(named: "player")
            imageView.image = image
            cell.backgroundView = UIView()
            cell.backgroundView!.addSubview(imageView)
            print("put image")
        }
        
        
        
        cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: mapCollectionView.frame.width/7, height: mapCollectionView.frame.height/7)
 
        return cell
        
    }
    
    
}


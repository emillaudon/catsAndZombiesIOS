//
//  ViewController.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-05.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet var backGroundView: UIView!
    @IBOutlet var backgroundLayers: [UIImageView]!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet var gestureRecognizers: [UISwipeGestureRecognizer]!
    
    @IBOutlet weak var fadeView: UIView!
    
    @IBOutlet weak var catView: UIView!
    
    @IBOutlet weak var touchView: UIView!
    var map: Map!
    var cats = [Cat]()
    
    var playerX = 0
    var playerY = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = Map()
        
        for index in 1...8 {
            cats.append(Cat())
        }
        
        for cat in cats {
            print(cat.position.x)
            print(cat.position.y)
        }
        
        let cat1 = Cat()
        cat1.position.x = 1
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
    
    func checkForCatsInSameCoordinates(cats: [Cat]) {
        var catsXValue = [Int]()
        var catsYValue = [Int]()
        for cat in cats {
            if !catsYValue.contains(cat.position.y) && !catsXValue.contains(cat.position.x){
                catsXValue.append(cat.position.x)
                catsYValue.append(cat.position.y)
            } else {
                cat.changePosition(of: cat)
                //checkForCatsInSameCoordinates(cats: cats)
                return
            }
        }
    }
    
    func updatePositionLabel() {
        positionLabel.text = "x: \(playerX) y: \(playerY)"
    }
    
    func moveToNewPosition() {
        for cat in cats {
            cat.addMoveCount(to: cat)
        }
        checkForCatsInSameCoordinates(cats: cats)
        fadeScreen()
    }
    
    func fadeScreen() {
        for recognizer in gestureRecognizers {
            recognizer.isEnabled = false
        }
        self.backGroundView.bringSubviewToFront(fadeView)
        UIView.animate(withDuration: 1.0, animations: {
            self.fadeView.alpha = 1.0
        }) { (completion) in
            self.updateLayers(using: self.map)
            UIView.animate(withDuration: 1.0, animations: {
                self.fadeView.alpha = 0.0
            }) { (completion) in
                for recognizer in self.gestureRecognizers {
                    recognizer.isEnabled = true
                }
                self.backGroundView.sendSubviewToBack(self.fadeView)
            }
        }
    }
    
    func drawCat(cat: Cat) {
        let catImage = cat.sprite
        
        let catButton = UIButton()
        
        catButton.setBackgroundImage(catImage, for: .normal)
        
        catButton.frame = CGRect(x: 10, y: 471, width: 130, height: 130)
        catButton.addTarget(self, action:#selector(self.catTapped(_:)), for: .touchUpInside)
        
        touchView.addSubview(catButton)
        
        catButton.isUserInteractionEnabled = true
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
    @objc func catTapped(_ sender: UIButton?) {
        print("tapped")
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


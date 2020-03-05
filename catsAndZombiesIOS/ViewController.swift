//
//  ViewController.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-05.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet var backgroundLayers: [UIImageView]!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet var gestureRecognizers: [UISwipeGestureRecognizer]!
    
    @IBOutlet weak var fadeView: UIView!
    
    @IBOutlet weak var catView: UIView!
    
    var map: Map!
    var cats = [Cat]()
    
    var playerX = 0
    var playerY = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = Map()
        
        cats.append(Cat())
        cats.append(Cat())
        
        for cat in cats {
            print(cat.position.x)
            print(cat.position.y)
        }
        
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
        removeCats()
        for cat in cats {
            if cat.position.x == playerX && cat.position.y == playerY {
                drawCat(cat: cat)
            }
        }
    }
    
    func updatePositionLabel() {
        positionLabel.text = "x: \(playerX) y: \(playerY)"
    }
    
    func moveToNewPosition() {
        fadeScreen()
    }
    
    func fadeScreen() {
        for recognizer in gestureRecognizers {
            recognizer.isEnabled = false
        }
        
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
            }
        }
    }
    
    func drawCat(cat: Cat) {
        let catImage = cat.sprite
        
        let catImageView = UIImageView(image: catImage)
        
        catImageView.frame = CGRect(x: 10, y: 471, width: 130, height: 130)
        catView.addSubview(catImageView)
        
    }
    
    func removeCats() {
        for subView in catView.subviews {
            subView.removeFromSuperview()
        }
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


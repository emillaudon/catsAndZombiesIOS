//
//  Cat.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-05.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import Foundation
import UIKit

class Cat {
    var turnsSinceMoving: Int
    let sprite: UIImage
    var position: Point
    
    init() {
        self.turnsSinceMoving = 0
        self.sprite = UIImage(named: "cat\(Int.random(in: 1...3))")!
        self.position = Point(x: Int.random(in: 1...7), y: Int.random(in: 1...7))
    }
    
    func addTurn() {
        self.turnsSinceMoving += 1
        
        if self.turnsSinceMoving == 2 {
            self.turnsSinceMoving = 0
            self.changePosition()
        }
    }
    
    func changePosition() {
        if Int.random(in: 1...2) == 1 {
            if Int.random(in: 1...2) == 1 && self.position.x < 6{
                self.position.x += 1
            } else if self.position.x > 0 {
                self.position.x -= 1
            }
        } else {
            if Int.random(in: 1...2) == 1 && self.position.y < 6{
                self.position.y += 1
            } else if self.position.y > 0 {
                self.position.y -= 1
            }
        }
    }
    
}

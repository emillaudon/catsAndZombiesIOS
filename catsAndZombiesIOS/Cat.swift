//
//  Cat.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-05.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import Foundation
import UIKit

class Cat: Comparable {
    
    var playerMovesSinceMoving: Int
    let sprite: UIImage
    var position: Point
    let catID: String
    
    init() {
        self.playerMovesSinceMoving = 0
        self.sprite = UIImage(named: "cat\(Int.random(in: 1...3))")!
        self.position = Point(x: Int.random(in: 1...6), y: Int.random(in: 1...6))
        self.catID = UUID().uuidString
    }
    
    func addMoveCount(to cat: Cat) {
            cat.playerMovesSinceMoving += 1
            
            if cat.playerMovesSinceMoving == 2 {
                cat.playerMovesSinceMoving = 0
                self.changePosition()
        }
    }
    
    func changePosition(of cats: [Cat]) {
        for cat in cats {
            if Int.random(in: 1...2) == 1 {
                if Int.random(in: 1...2) == 1 && cat.position.x < 6{
                    cat.position.x += 1
                } else if cat.position.x > 0 {
                    cat.position.x -= 1
                }
            } else {
                if Int.random(in: 1...2) == 1 && cat.position.y < 6{
                    cat.position.y += 1
                } else if cat.position.y > 0 {
                    cat.position.y -= 1
                }
            }
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
    
    static func < (lhs: Cat, rhs: Cat) -> Bool {
        return true
    }
    
    static func == (lhs: Cat, rhs: Cat) -> Bool {
        return lhs.catID == rhs.catID
    }
}

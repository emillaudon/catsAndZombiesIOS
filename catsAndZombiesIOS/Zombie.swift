//
//  Zombie.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-06.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import Foundation
import SpriteKit

class Zombie {
    var position: Point
    var playerMovesSinceMoving: Int
    let walkingAtlas: SKTextureAtlas
    
    init() {
        self.position = Point(x: Int.random(in: 5...6), y: Int.random(in: 3...6))
        self.playerMovesSinceMoving = 0
        self.walkingAtlas = SKTextureAtlas(named: "zombieWalkAtlas")
    }
    
    func addPlayerMoveToZombie(playerX: Int, playerY: Int) {
        self.playerMovesSinceMoving += 1
        if self.playerMovesSinceMoving > 2 {
            self.moveZombie(playerX: playerX, playerY: playerY)
            print("zombie moved")
        }
    }
    
    func moveZombie(playerX: Int, playerY: Int) {
        let coinflip = Int.random(in: 1...2)
        if coinflip == 1 {
            if playerX < self.position.x {
                self.position.x -= 1
            } else {
                self.position.x += 1
            }
        } else {
            if playerY < self.position.y {
                self.position.y -= 1
            } else {
                self.position.y += 1
            }
        }
    }
}

//
//  StartScreenScene.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-10.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class StartScreenScene: SKScene {
    var numb = 1
    
    let background1 = SKSpriteNode(imageNamed: "layer1")
    let background2 = SKSpriteNode(imageNamed: "layer10")
    let background22 = SKSpriteNode(imageNamed: "layer10")
    
    override func didMove(to view: SKView) {
        
        //background1.position = CGPoint(x: frame.size.width / 2, y:frame.size.height / 2)
        background1.position = CGPoint(x: 0, y: 0)
        background1.size = CGSize(width: frame.width, height: frame.height)
        //background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        background1.zPosition = -15
        self.addChild(background1)
        print("appended")


        background2.size = CGSize(width: frame.width, height: frame.height)
        //background2.anchorPoint = CGPoint.zero
        //background2.position =  CGPoint(x: background1.size.width - 1,y: 0)
        background2.position = CGPoint(x: 0, y: 0)
        background2.zPosition = -15
        self.addChild(background2)
        
        background22.size = CGSize(width: frame.width, height: frame.height)
        background22.position = CGPoint(x: background2.size.width, y: 0)
        background22.zPosition = -15
        self.addChild(background22)
        


    }

    
    override func update(_ currentTime: TimeInterval) {
        numb += 1

        background2.position = CGPoint(x: background2.position.x - 2, y: background2.position.y)
        background22.position = CGPoint(x: background22.position.x - 2, y: background22.position.y)

        if background2.position.x < -background2.size.width {
            background2.position = CGPoint(x: background22.position.x + background22.size.width, y: background2.position.y)
            print("1 moving\(background2.position.x)")
        }

        if background22.position.x < -background22.size.width {
            print("2 moving\(background22.position.x)")
            background22.position = CGPoint(x: background2.position.x + background2.size.width, y: background22.position.y)
        }
    }
}


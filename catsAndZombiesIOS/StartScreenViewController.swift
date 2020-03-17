//
//  StartScreenViewController.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-10.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class StartScreenViewController: UIViewController {
    @IBOutlet weak var spriteKitView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = StartScreenScene(fileNamed: "MyScene") {
            print("scen finns")
            scene.scaleMode = .aspectFill
            
            
            spriteKitView.presentScene(scene)
            scene.backgroundColor = .black
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

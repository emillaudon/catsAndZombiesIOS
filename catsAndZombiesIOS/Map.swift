//
//  Map.swift
//  catsAndZombiesIOS
//
//  Created by Emil Laudon on 2020-03-05.
//  Copyright © 2020 Emil Laudon. All rights reserved.
//

import Foundation

class Map {
    var coordinates = [[[Int]]]()
    
    init() {
        self.coordinates = []
        for _ in 1...7 {
            var tempArray = [[Int]]()
            for _ in 1...7 {
                var secondTempArray = [Int]()
                for _ in 1...10 {
                    let randomXValue = Int.random(in: -433 ..< 0)
                    secondTempArray.append(randomXValue)
                }
                tempArray.append(secondTempArray)
            }
            self.coordinates.append(tempArray)
        }
    }
    
}

//
//map = [];
//    for (k = 0; k < 7; k += 1) {
//        let tempArrayX = [];
//
//        for (j = 0; j < 7; j += 1) {
//            let tempArray13 = [];
//            for (i = 0; i < 14; i += 1) {
//                let tempNumber = getNonZeroRandomNumber();
//                tempArray13.push(tempNumber);
//
//            }
//
//            tempArrayX.push(tempArray13);
//
//        }
//        map.push(tempArrayX);
//    }
//}

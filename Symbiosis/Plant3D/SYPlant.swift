//
//  SYPlant.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 18/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SceneKit

/**
 * This class just create a root SYElement and create a RandomManager.
 **/
class SYPlant: SCNNode, SYRederable {
    
    var rootSYElem: SYElement! = nil
    
    let randomManager: SYRandomManager
    let bezierManager: SYBezierManager
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(progresses: [Float], randomManager: SYRandomManager, bezierManager: SYBezierManager) {
        self.randomManager = randomManager
        self.bezierManager = bezierManager
        
        super.init()
        let states = self.generateProps(progresses)
        var propsList: [Any] = []
        for state in states {
            propsList.append(state)
        }
        self.rootSYElem = SYElementRoot(propsList: propsList, positionsList: nil, orientationsList: nil, parent: self)
        
        self.addChildNode(self.rootSYElem)
    }
    
    func render(progress: Float) {
        self.rootSYElem.render(progress)
    }
    
    func getRandomManager() -> SYRandomManager {
        return self.randomManager
    }
    
    func getBezierManager() -> SYBezierManager {
        return self.bezierManager
    }

    func generateProps(progresses: [Float]) -> [SYElementRootProps] {
        var result :[SYElementRootProps] = []
        for progress in progresses {
            result.append(SYElementRootProps(size: progress, hasLeefs: false, nbrOfFlower: 0, nbrOfFruits: 0, nbrOfSeed: 0))
        }
        return result
    }
    
}

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
    let randomManager: SYRandomManager = SYRandomManager()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(states: [Float]) {
        
        var propsList: [Any] = []
        for state in states {
            propsList.append(SYElementRootProps(size: state))
        }
        super.init()
        self.rootSYElem = SYElementRoot(propsList: propsList, positionsList: nil, orientationsList: nil, parent: self)
        
        self.addChildNode(self.rootSYElem)
    }
    
    func render(progress: Float) {
        self.rootSYElem.render(progress)
    }
    
    func getRandomManager() -> SYRandomManager {
        return self.randomManager
    }
    
}

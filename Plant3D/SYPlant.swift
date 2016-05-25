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
class SYPlant: SCNNode {
    
    var rootSYElem: SYElement
    let randomManager: SYRandomManager = SYRandomManager()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(from startSize: Float, to endSize: Float) {
        super.init()
        
        let propsList: [Any] = [SYElementRootProps(size: startSize), SYElementRootProps(size: endSize)]
        self.rootSYElem = SYElementRoot(propsList: propsList, positionsList: nil, orientationsList: nil)
        
        self.addChildNode(self.rootSYElem)
    }
    
}

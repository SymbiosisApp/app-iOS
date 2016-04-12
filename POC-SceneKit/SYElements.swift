//
//  SYElements.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 11/04/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

class SYElementBranch: SYElement {
    
    override func generateSelfGeom(state: Float) {
        let options1: [String:Any] = [
            "size" : Float(1),
            "rotate" : Float(0.1)
        ]
        let geom = SYShapeTwist(options: options1)
        self.geometries.addChildNode(geom)
    }
    
    override func generateChildren(state: Float) {
//        let options1: [String:Any] = [:]
//        let child = SYShape(options: options1)
//        child.render(state)
//        self.addChildNode(child)
//        child.position = SCNVector3Make(0, 1, 1)
    }
    
    
}
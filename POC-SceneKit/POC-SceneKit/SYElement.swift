//
//  SYElement.swift
//  POC-SceneKit
//
//  Created by Etienne De Ladonchamps on 29/03/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SceneKit

class SYElement: SCNNode {
    let geometries = SCNNode()
    
    override init() {
        super.init()
        self.geometries.name = "geometries"
        self.addChildNode(self.geometries)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateSelfGeom(state: Float) {
        let options1: [String:Any] = [
            "size" : Float(1),
            "rotate" : Float(0.1)
        ]
        let geom = SYShapeTwist(options: options1)
        self.geometries.addChildNode(geom)
    }
    
    func renderSelfGeom(state: Float) {
        for selfGeom in self.geometries.childNodes {
            let geom = selfGeom as! SYShape
            geom.render(state)
        }
    }
    
    func renderChildren(state: Float) {
        let options1: [String:Any] = [:]
        let child = SYShape(options: options1)
        child.render(state)
        self.addChildNode(child)
        child.position = SCNVector3Make(0, 1, 1)
    }
    
    func render(state: Float) {
        self.generateSelfGeom(state)
        self.renderSelfGeom(state)
        self.renderChildren(state)
    }

}
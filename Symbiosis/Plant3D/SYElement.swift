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
    let children = SCNNode()
    
    override init() {
        super.init()
        self.geometries.name = "geometries"
        self.addChildNode(self.geometries)
        self.children.name = "children"
        self.addChildNode(self.children)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateSelfGeom(state: Float) {
        let options1: SYShapeTwistProps = SYShapeTwistProps(size: 1.0, rotate: 0.1)

        let geom = SYShapeTwist(props: options1)
        self.geometries.addChildNode(geom)
    }
    
    func renderSelfGeom(state: Float) {
        if self.geometries.childNodes.count == 0 {
            return
        }
        for selfGeom in self.geometries.childNodes {
            let geom = selfGeom as! SYShape<SYPropsDefault>
            geom.render(state)
        }
    }
    
    func generateChildren(state: Float) {
//        let options1: [String:Any] = [:]
//        let child = SYShape(options: options1)
//        child.render(state)
//        self.addChildNode(child)
//        child.position = SCNVector3Make(0, 1, 1)
    }
    
    func renderChildren(state: Float) {
        if self.children.childNodes.count == 0 {
            return
        }
        for child in self.children.childNodes {
            let elem = child as! SYElement
            let childState = self.transformStateForChild(elem, state: state)
            elem.render(childState)
        }
    }
    
    func transformStateForChild(child: SYElement, state: Float) -> Float {
        return state
    }
    
    func render(state: Float) {
        self.generateSelfGeom(state)
        self.generateChildren(state)
        self.renderSelfGeom(state)
        self.renderChildren(state)
    }

}
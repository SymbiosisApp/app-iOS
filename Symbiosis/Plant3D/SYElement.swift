////
////  SYElement.swift
////  POC-SceneKit
////
////  Created by Etienne De Ladonchamps on 29/03/2016.
////  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
////
//
//import Foundation
//import SceneKit
//
//class SYElement<T>: SCNNode {
//    let geometries = SCNNode()
//    let children = SCNNode()
//    
//    let startProps: T
//    let endProps: T?
//    
//    init(startProps: T, endProps: T?) {
//        super.init()
//        
//        self.geometries.name = "geometries"
//        self.addChildNode(self.geometries)
//        self.children.name = "children"
//        self.addChildNode(self.children)
//        
//        self.startProps = startProps
//        self.endProps = endProps
//        
//        self.generateSelfGeom()
//        self.generateChildren()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func generateSelfGeom() {}
//    
//    func generateChildren() {}
//    
//    func render(progress: Float?) {
//        // self.renderSelfGeom(progress)
//        if self.geometries.childNodes.count == 0 {
//            return
//        }
//        for selfGeom in self.geometries.childNodes {
//            let geom = selfGeom as! SYShape
//            geom.render(progress)
//        }
//        
//        // self.renderChildren(progress)
//        if self.children.childNodes.count == 0 {
//            return
//        }
//        for child in self.children.childNodes {
//            let elem = child as! SYElement
//            elem.render(progress)
//        }
//    }
//    
//}
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
    override init() {
        super.init()
        
        // material
        let redMataterialBis = SCNMaterial()
        redMataterialBis.diffuse.contents = UIColor.blueColor()
        redMataterialBis.doubleSided = true
        
        let options1: [String:Any] = [:]
        let customGeo1 = SYShape(options: options1).geometry!
        customGeo1.materials = [redMataterialBis]

        self.geometry = customGeo1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
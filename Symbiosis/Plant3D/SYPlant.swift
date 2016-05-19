////
////  SYPlant.swift
////  symbiosis-ios-app
////
////  Created by Etienne De Ladonchamps on 18/05/2016.
////  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
////
//
//import Foundation
//import SceneKit
//
//
//class SYPlant: SCNNode {
//    
//    let startSize: Float
//    let endSize: Float
//    
//    var randoms: [String: Float] = [:]
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    init(from startSize: Float, to endSize: Float) {
//        super.init()
//        
//        self.startSize = startSize
//        self.endSize = endSize
//        
//        let typeNode = SYElementBaseTypes()
//        
//        self.addChildNode(typeNode)
//    }
//    
//    func getRandom(key: String) -> Float {
//        print(randoms[key])
//        return 0
//    }
//    
//}
//
//class SYPlantRoot: SYPlant {
//    
//
//    
//}

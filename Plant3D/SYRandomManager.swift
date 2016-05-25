//
//  SYRandomManager.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 25/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

class SYRandomManager {
    
    var randoms: [String: Int] = [:];
    
    func get(randomKey: String) -> Int {
        if self.randoms[randomKey] == nil {
            self.randoms[randomKey] = random();
        }
        return self.randoms[randomKey]!
    }

}
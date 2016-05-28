//
//  Utils.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 12/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

func UtilsRandom(withRandom random: Int, between min: Float, and max: Float) -> Float {
    let diff = max - min
    return min + (Float(random / 1000) % diff)
}
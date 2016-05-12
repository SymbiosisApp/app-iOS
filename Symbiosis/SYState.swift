//
//  SYState.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 09/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation

/**
 * Class to manage the state of the app
 **/
class SYState {
    static let sharedInstance = SYState()
    private init() {} //This prevents others from using the default '()' initializer for this class.
}
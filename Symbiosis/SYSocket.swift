//
//  SocketSingleton.swift
//  gob-swift-eval
//
//  Created by Etienne De Ladonchamps on 24/03/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import SocketIOClientSwift


class SYSocket {
    
    static let sharedInstance = SYSocket()
    
    let io = SocketIOClient(socketURL: NSURL(string: "http://192.168.1.75:8000")!, options: [.Log(true), .ForcePolling(true)])
    
    private init() {
        self.io.on("connect") {data, ack in
            print("socket connected")
        }
        
        self.io.connect()
    }
    
}
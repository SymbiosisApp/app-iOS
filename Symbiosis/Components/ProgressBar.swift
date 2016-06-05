//
//  ProgressBar.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 31/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class SYProgressBar: UIView, SYStateListener {

    // MARK: State
    let state = SYStateManager.sharedInstance
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        state.addListener(self)
        
        
    }
    
    
    func onStateSetup() {
        
    }
    
    func onStateUpdate() {
        
    }

}
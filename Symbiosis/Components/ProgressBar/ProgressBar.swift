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
    var nibName: String = "ProgressBar"
    
    @IBOutlet weak var containerProgressBar: UIView!
    @IBOutlet weak var liquidProgressBar: UIView!

    @IBOutlet var view: UIView!
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    // MARK: Setup
    func setup() {
        state.addListener(self)
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
        containerProgressBar.layer.cornerRadius = 2.0
        containerProgressBar.clipsToBounds = true
        
        //TODO
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    func onStateSetup() {
        
    }
    
    func onStateUpdate() {
        
    }

}
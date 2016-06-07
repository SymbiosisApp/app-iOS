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
        
        progressBar()
    }
    
    func progressBar(){
        
        var progress = liquidProgressBar.frame
        var heightLiquidProgressBar = liquidProgressBar.frame
        let heightContainerProgressBar = containerProgressBar.frame.height
        let randomValue = CGFloat(randRange(1, upper: 99))
        
        progress.origin.y = heightContainerProgressBar - ((randomValue * heightContainerProgressBar)/100)
        heightLiquidProgressBar = progress
        
        self.containerProgressBar.addSubview(UIView(frame: heightLiquidProgressBar))
        
        UIView.animateWithDuration(0.8, animations: {
            self.liquidProgressBar.frame = CGRectMake(progress.origin.x, progress.origin.y, progress.height, progress.width)
        })

    }
    
    func randRange (lower: UInt32 , upper: UInt32) -> UInt32 {
        return lower + arc4random_uniform(upper - lower + 1)
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
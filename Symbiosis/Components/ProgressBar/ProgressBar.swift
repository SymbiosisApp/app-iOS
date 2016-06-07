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
    var barHeightConstraint: NSLayoutConstraint? = nil
    
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
        print("setup")
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
        self.barHeightConstraint = NSLayoutConstraint.init(item: liquidProgressBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: containerProgressBar, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: 0)
        self.barHeightConstraint?.active = true
        
        self.layoutIfNeeded()

        state.addListener(self)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func animateTo(progress: Float) {
        UIView.animateWithDuration(1.0, animations: {
            if self.barHeightConstraint != nil {
                self.barHeightConstraint!.active = false
            }
            self.barHeightConstraint = NSLayoutConstraint.init(item: self.liquidProgressBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.containerProgressBar, attribute: NSLayoutAttribute.Height, multiplier: CGFloat(progress), constant: 0)
            self.barHeightConstraint!.active = true
            self.layoutIfNeeded()
        }) { (completed) in
            print("done")
        }
    }
    
    func onStateSetup() {
        let progress = state.getProgressBarProgress()
        self.animateTo(progress)
    }
    
    func onStateUpdate() {
        if state.plantStatusHasChanged() {
            let newStatus = state.getPlantStatus()
            switch newStatus {
            case .Generated:
                break
            case .Animating:
                let progress = state.getProgressBarProgress()
                self.animateTo(progress)
            case .Animated:
                // Do Nothing
                break
            case .Generating:
                // Do Nothing
                break
            case .NotGenerated:
                // Do Nothing
                break
            }

        }
    }

}
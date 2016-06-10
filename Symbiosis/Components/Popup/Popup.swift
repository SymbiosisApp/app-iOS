//
//  Popup.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 02/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class SYPopup: UIView, SYStateListener {
    
    let validPopups : [String] = ["commencer", "commenter", "decouverte", "dispersion", "fruit", "lieu", "merci", "photo", "suggerer", "colony"]
    
    // MARK: State
    let state = SYStateManager.sharedInstance
    
    var currentPopup: UIView? = nil
    var constBottom: NSLayoutConstraint? = nil
    var blurEffectView: UIView? = nil
    
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
        
        self.userInteractionEnabled = true
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView!.frame = self.bounds
        //blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        // self.addSubview(blurEffectView!)
        
        self.hidden = true
    }
    
    // - MARK: Update
    
    func onStateSetup() {
        if self.currentPopup != nil {
            hidePopup()
        }
        let currentPopupName = state.getCurrentPopup()
        if currentPopupName != nil {
            if validPopups.indexOf(currentPopupName!) != nil {
                showPopup(currentPopupName!)
            } else {
                print("Invalid popup name : \(currentPopupName!)")
            }
        }
    }
    
    func onStateUpdate() {
        if state.popupHasChanged() {
            self.onStateSetup()
        }
    }
    
    func blurEffect(){

    }
    
    func hidePopup() {
        // self.blurEffectView!.hidden = true
        let popupToRemove = self.currentPopup!
        UIView.animateWithDuration(0.3, animations: { 
            self.constBottom?.constant = 200
            popupToRemove.alpha = 0
            // self.blurEffectView!.alpha = 0
            self.layoutIfNeeded()
            }) { (completed) in
                if self.state.getCurrentPopup() == nil {
                    self.hidden = true
                }
        }
    }
    
    func showPopup(name: String) {
        var newPopup: UIView? = nil
        if name == "colony" {
            newPopup = SYColony(frame: self.frame)
        } else {
            newPopup = SYImagePopup(frame: self.frame, imageName: name)
        }
        self.currentPopup = newPopup
        
        self.addSubview(self.currentPopup!)

        // Constraints
        self.currentPopup?.translatesAutoresizingMaskIntoConstraints = false;
        let constWidth = NSLayoutConstraint.init(item: self.currentPopup!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        constWidth.active = true
        let constHeight = NSLayoutConstraint.init(item: self.currentPopup!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        constHeight.active = true
        let constLeft = NSLayoutConstraint.init(item: self.currentPopup!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        constLeft.active = true
        self.constBottom = NSLayoutConstraint.init(item: self.currentPopup!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 200)
        self.constBottom!.active = true
        self.currentPopup!.alpha = 0
        self.layoutIfNeeded()
        self.hidden = false
        
        // self.blurEffectView!.hidden = false
        UIView.animateWithDuration(0.3, animations: { 
            self.constBottom!.constant = 0
            // self.blurEffectView!.alpha = 0.7
            self.layoutIfNeeded()
            self.currentPopup!.alpha = 1
            }) { (completed) in
                // print("completed")
        }
    }
    
}

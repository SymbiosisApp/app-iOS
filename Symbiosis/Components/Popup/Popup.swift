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
    
    // MARK: Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var buttonclose: UIButton!
    @IBOutlet weak var imagePopup: UIImageView!
    
    let validPopups : [String] = ["commencer", "commenter", "decouverte", "dispersion", "fruit", "lieu", "merci", "photo", "suggerer"]
    
    let background = Background()
    
    // MARK: Properties
    var nibName: String = "Popup"
    
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
    
    // MARK: Setup
    func setup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
        view.superview!.hidden = true
        
        buttonclose.addTarget(self, action:#selector(self.hideCurrentPopup), forControlEvents: .TouchUpInside)
        
        
        state.addListener(self)
    }
    
    func hideCurrentPopup() {
        if state.getCurrentPopup() == "commencer" {
            state.dispatchAction(SYStateActionType.HideCurrentPopup, payload: nil)
            state.dispatchAction(SYStateActionType.SetUserSeed, payload: "Blabla")
        }
        
        state.dispatchAction(SYStateActionType.HideCurrentPopup, payload: nil)
    }
   
    
    func closePopup(){
        // TODO add transition
        view?.superview!.removeFromSuperview()
        view.removeFromSuperview()
    }


    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    
    // - MARK: Update
    
    func onStateSetup() {
        let currentPopup = state.getCurrentPopup()
        if let popupName = currentPopup {
            if validPopups.indexOf(popupName) != nil {
                showPopup(popupName)
            } else {
                print("Invalid popup name : \(popupName)")
            }
        } else {
            hidePopup()
        }
    }
    
    func onStateUpdate() {
        
        if state.popupHasChanged() {
            let currentPopup = state.getCurrentPopup()
            if let popupName = currentPopup {
                if validPopups.indexOf(popupName) != nil {
                    showPopup(popupName)
                } else {
                    print("Invalid popup name : \(popupName)")
                }
            } else {
                hidePopup()
            }
        }
    }
    
    func addBackgroundPopup(image:String){
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: image)
        imagePopup.insertSubview(backgroundImage, atIndex: 0)
    }
    
    func hidePopup() {
        if (view.superview != nil) {
            let parentView = view.superview!
            parentView.hidden = true
        }
    }
    
    func showPopup(name: String) {
        addBackgroundPopup(name)
        if let parentView = view.superview {
            parentView.hidden = false
        } else {
            print("No parent view, snif :'(")
        }
    }


    
}

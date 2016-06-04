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
    
    let viewsNames: [String] = ["Profil", "Map", "Plant", "Colony", "Settings"]
    var tabStoryboards: [UIStoryboard?] = [nil, nil, nil, nil, nil]
    var tabViews: [UIViewController?] = [nil, nil, nil, nil, nil]
    let popupNames : [String] = ["commencer", "commenter", "decouverte", "dispersion", "fruit", "lieu", "merci", "photo", "suggerer"]
    
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
        state.addListener(self)
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
        buttonclose.addTarget(self, action:#selector(self.closePopup), forControlEvents: .TouchUpInside)
        //addBackgroundPopup("partage")
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
    func onStateUpdate() {
        let parentView = view.superview
        
        if state.popupHasChanged() {
            //let currentPopup = state.getCurrentPopup()
            // si deja une popup on la tej
            // sinon current popup est pas nil on la display
            
            //print(popupNames[currentPopup])
        }
        
        
        if state.tabHasChanged() {
            let currentTab = state.getSelectedTab()
            
            if currentTab < viewsNames.count {
                
                //TODO replace "Map" by popNames[currentPopup]
                if("Map" == viewsNames[currentTab]){
                    parentView?.hidden = false
                    
                    //if("Map" == viewsNames[currentTab] && popupNames[currentPopup] == "timer"){
                        //parentView?.userInteractionEnabled = false
                        //buttonClose hidden
                    //}
                    
                }else{
                    parentView?.hidden = true
                }
                
            }
        }
    }
    
    func addBackgroundPopup(image:String){
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: image)
        imagePopup.insertSubview(backgroundImage, atIndex: 0)
    }


    
}

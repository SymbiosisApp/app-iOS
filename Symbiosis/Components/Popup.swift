//
//  Popup.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 02/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class SYPopup: UIView {
    
    // MARK: Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var plantButton: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet var buttons: Array<UIButton>!
    
    
    @IBOutlet weak var buttonclose: UIButton!

    
    let viewsNames: [String] = ["Profil", "Map", "Plant", "Colony", "Settings"]
    var tabStoryboards: [UIStoryboard?] = [nil, nil, nil, nil, nil]
    var tabViews: [UIViewController?] = [nil, nil, nil, nil, nil]

    
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
        state.listenTo(.Update, action: self.onStateUpdate)
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        addSubview(view)
        
        print("------yolo---------")
        
        
        state.listenTo(.Update, action: self.onStateUpdate)
        onStateUpdate()
        
        buttonclose.addTarget(self, action:#selector(self.closePopup), forControlEvents: .TouchUpInside)

        
        
    }
    
    func someAction(sender:UITapGestureRecognizer){

        print("yolo")
        
    }

    
    func closePopup(){
        //view?.removefromsuperView
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

        if state.tabHasChanged() {

        let currentTab = state.getSelectedTab()
        if currentTab < viewsNames.count {
                if("Plant" == viewsNames[currentTab]){
                    
                    parentView?.hidden = false
                }else{
                    parentView?.hidden = true

                }
            }
        }
    }

    
}

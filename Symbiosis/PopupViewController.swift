//
//  SYPopup.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 01/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController{
    
    let viewsNames: [String] = ["Profil", "Map", "Plant", "Colony", "Settings"]
    var tabStoryboards: [UIStoryboard?] = [nil, nil, nil, nil, nil]
    var tabViews: [UIViewController?] = [nil, nil, nil, nil, nil]
    let state = SYStateManager.sharedInstance
    
    var popupData: NSDictionary?

    @IBOutlet weak var blurPopupView: UIView!
    @IBOutlet weak var imagePopup: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state.listenTo(.Update, action: self.onStateUpdate)
        onStateUpdate()
        
        for (_, value) in popupData! {
            let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
            backgroundImage.image = UIImage(named: value as! String)
            imagePopup.insertSubview(backgroundImage, atIndex: 0)
        }
                
        blurEffect()
    }

    func blurEffect(){

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.6
        blurEffectView.frame = view.bounds
        //blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurPopupView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.size.height)
        blurPopupView.addSubview(blurEffectView)
    }
    

    func onStateUpdate() {
            let currentTab = state.getSelectedTab()
            if currentTab < viewsNames.count {
    
            for (key, _) in popupData! {
                if(key as! String == viewsNames[currentTab]){
                    view.hidden = false
                }else{
                    view.hidden = true
                }
            }
        }
    }
    
}
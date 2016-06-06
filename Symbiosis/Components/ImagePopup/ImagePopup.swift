//
//  colonie.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 05/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class SYImagePopup: UIView {

    
    @IBOutlet var view: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    // State
    let state = SYStateManager.sharedInstance
    
    // MARK: Init
    var nibName: String = "ImagePopup"

    init(frame: CGRect, imageName: String) {
        super.init(frame: frame)
        setup(imageName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    func setup(imageName: String) {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: imageName)
        image.insertSubview(backgroundImage, atIndex: 0)

        closeButton.addTarget(self, action:#selector(self.closeAction), forControlEvents: .TouchUpInside)
  
    }
    
    func closeAction(){
        print("Hide image popup")
        state.dispatchAction(SYStateActionType.HideCurrentPopup, payload: nil)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
}
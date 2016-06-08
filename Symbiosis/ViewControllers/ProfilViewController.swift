//
//  ProfilViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 28/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

class ProfilViewController: UIViewController, SYStateListener {
    
    let state = SYStateManager.sharedInstance
    
    @IBOutlet weak var counterSteps: UILabel!
    @IBOutlet weak var stepsKm: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        
        //Foreach STEPS titre+date
        let background = Background()
        let titre = UILabel(frame: CGRectMake(0, 0, 200, 21))
        titre.center = CGPointMake(133, 250)
        titre.textAlignment = NSTextAlignment.Center
        titre.text = "GERMINATION"
        titre.textColor = background.hexStringToUIColor("#FF9C8F")
        titre.font = UIFont(name: "Campton", size: 15.0)
        titre.font = UIFont.boldSystemFontOfSize(15)
        self.view.addSubview(titre)
        
        let date = UILabel(frame: CGRectMake(0, 0, 200, 21))
        date.center = CGPointMake(128, 270)
        date.textAlignment = NSTextAlignment.Center
        date.text = "- le 02.05.16"
        date.textColor = background.hexStringToUIColor("#BBB3B3")
        date.font = UIFont(name: "Campton", size: 15.0)
        self.view.addSubview(date)
        
        button.backgroundColor = background.hexStringToUIColor("#77B4F7")
        
        state.addListener(self)
    }
    
    
    func onStateSetup() {
        let steps = state.getCurrentTotalSteps()
        self.counterSteps.text = String(steps)
        
        let kilometer = steps/1300
        self.stepsKm.text = String(kilometer)
            
    }
    
    func onStateUpdate() {
        if state.getCurrentTotalSteps() != state.getPreviousTotalSteps(){
            self.onStateSetup()
        }
        
    }
    
}
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
        let background = Background()

        //Foreach STEPS titre+date
        let titre1 = UILabel(frame: CGRectMake(0, 0, 200, 21))
        titre1.center = CGPointMake(160, 250)
        titre1.textAlignment = NSTextAlignment.Center
        titre1.text = "CHOIX D'UNE GRAINE"
        titre1.textColor = background.hexStringToUIColor("#FF9C8F")
        titre1.font = UIFont(name: "Campton", size: 15.0)
        titre1.font = UIFont.boldSystemFontOfSize(15)
        self.view.addSubview(titre1)
        
        let date1 = UILabel(frame: CGRectMake(0, 0, 200, 21))
        date1.center = CGPointMake(128, 270)
        date1.textAlignment = NSTextAlignment.Center
        date1.text = "- le 09.06.16"
        date1.textColor = background.hexStringToUIColor("#BBB3B3")
        date1.font = UIFont(name: "Campton", size: 15.0)
        self.view.addSubview(date1)

        
        //Foreach STEPS titre+date
        let titre = UILabel(frame: CGRectMake(0, 0, 200, 21))
        titre.center = CGPointMake(133, 300)
        titre.textAlignment = NSTextAlignment.Center
        titre.text = "GERMINATION"
        titre.textColor = background.hexStringToUIColor("#FF9C8F")
        titre.font = UIFont(name: "Campton", size: 15.0)
        titre.font = UIFont.boldSystemFontOfSize(15)
        self.view.addSubview(titre)
        
        let date = UILabel(frame: CGRectMake(0, 0, 200, 21))
        date.center = CGPointMake(128, 320)
        date.textAlignment = NSTextAlignment.Center
        date.text = "- le 09.06.16"
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
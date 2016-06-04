//
//  SuggestionViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 04/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func closeSuggestion(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

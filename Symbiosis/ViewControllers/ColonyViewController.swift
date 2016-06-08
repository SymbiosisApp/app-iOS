//
//  ColonyViewController.swift
//  symbiosis-ios-app
//
//  Created by Quentin Tshaimanga on 06/06/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import UIKit

class ColonyViewController: UIViewController {

    let request = RequestData()
    
    @IBOutlet weak var apprentisName: UILabel!
    @IBOutlet weak var fondateurName: UILabel!
    @IBOutlet weak var colonyName: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    let background = Background()
    override func viewDidLoad() {
        super.viewDidLoad()

        let usersData = request.getData("http://symbiosis.etienne-dldc.fr/users/id=5&param=all")
        let colonyData = request.getData("http://symbiosis.etienne-dldc.fr/graines/id=5")
        
        mainButton.backgroundColor = Background().hexStringToUIColor("#77B4F7")
        
        if let users = usersData as? [AnyObject]{
            for user in users {
                print("user", user)
                
                if let seed = user["parent"] as? String {
                    print("graine", seed)
                }
                if let user = user["pseudo"] as? String {
                    // apprentisName.text = user.uppercaseString
                    apprentisName.text = "Apprentis".uppercaseString
                }
            }
        }
    
        if let colony = colonyData as? [AnyObject]{
            
            for (index, users) in colony.enumerate() {
                
                if (index == colony.endIndex-1) {
                    
                    if let user = users["USER.pseudo"] as? String {
                        print("fondateur", user)
                        fondateurName.text = user
                        fondateurName.textColor = background.hexStringToUIColor("#FF9C8F")
                    }
                    
                }else{
                    
                    if let user = users["USER.pseudo"] as? String {
                        print("apprentis", user)
                        
                        let imageName = "photoUser"
                        let image = UIImage(named: imageName)
                        let imageView = UIImageView(image: image!)
                        imageView.frame = CGRect(x: 20+(index*70), y: 15, width: 60, height: 60)
                        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
                        imageView.clipsToBounds = true
                        imageView.layer.borderWidth = 2.0;
                        imageView.layer.borderColor = UIColor.clearColor().CGColor
                        
                        self.scrollView.addSubview(imageView)
                        
                        if "Chloé" == users["USER.pseudo"] as? String {
                            if let seedName = users["GRAINE.nom"] as? String {
                                colonyName.text = seedName
                            }
                        }
                    }
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*0.60, self.scrollView.frame.height)
                }
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}

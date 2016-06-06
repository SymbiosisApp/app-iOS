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
//    let name: String! = nil
//    let fondateName:String! = nil
//    let apprentisName:[String]! = nil
//    let userSeed: Int! = 0
    
    @IBOutlet weak var apprentisName: UILabel!
    @IBOutlet weak var fondateurName: UILabel!
    @IBOutlet weak var colonyName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    let background = Background()
    override func viewDidLoad() {
        super.viewDidLoad()


        let usersData = request.getData("http://symbiosis.etienne-dldc.fr/users/id=5&param=all")
        let colonyData = request.getData("http://symbiosis.etienne-dldc.fr/graines/id=5")
        
        
        if let users = usersData as? [AnyObject]{
            for user in users {
                print("user", user)
                
                if let seed = user["parent"] as? String {
                    print("graine", seed)
                }
                if let user = user["pseudo"] as? String {
                    apprentisName.text = user
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
                        
                        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 45+(index*70), y: 42), radius: CGFloat(25), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                        
                        let shapeLayer = CAShapeLayer()
                        shapeLayer.path = circlePath.CGPath
                        
                        shapeLayer.fillColor = UIColor.whiteColor().CGColor
                        shapeLayer.strokeColor = UIColor.lightGrayColor().CGColor
                        shapeLayer.lineWidth = 2.0
                        self.scrollView.layer.addSublayer(shapeLayer)
                        
                        if "Chloé" == users["USER.pseudo"] as? String {
                            if let seedName = users["GRAINE.nom"] as? String {
                                colonyName.text = seedName
                            }
                        }
                    }
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*1, self.scrollView.frame.height)
                }
            }
            
        }
        
     
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}

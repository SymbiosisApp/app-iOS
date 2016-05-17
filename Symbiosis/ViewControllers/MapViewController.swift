//
//  MapViewController.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 17/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import UIKit

// Mapbox is added "manualy", not with carthage
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // set the map’s center coordinate and zoom level
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
    }
    
}
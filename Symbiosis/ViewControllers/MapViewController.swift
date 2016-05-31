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
    let request = RequestData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURLWithVersion(9))
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // set the map’s center coordinate and zoom level
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 48.853138550976446, longitude: 2.348756790161133), zoomLevel: 12, animated: false)
        
        mapView.tintColor = .darkGrayColor()
        view.addSubview(mapView)
        mapView.delegate = self
        
        
        
        //GRAINE
        let dataMap = request.getData("http://localhost:8080/graines/")
        var latitude:Double = 0
        var longitude:Double = 0
        var name:String = ""
        
        if let data = dataMap as? [AnyObject]{
            for graine in data {
   
                if let graineInfo = graine["latitude"] as? String {
                    latitude = Double(graineInfo)!
                }
                if let graineInfo = graine["longitude"] as? String {
                    longitude = Double(graineInfo)!
                }
                if let graineInfo = graine["nom"] as? String {
                    name = String(UTF8String: graineInfo)!
                }
                
                let graine = MGLPointAnnotation()
                graine.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                graine.title = name
                mapView.addAnnotation(graine)
            }
        }
        
        
        //POLLEN
        let pollenDataMap = request.getData("http://localhost:8080/pollens/")
        var pollenLatitude:Double = 0
        var pollenLongitude:Double = 0
        
        if let data = pollenDataMap as? [AnyObject]{
            for pollen in data {
                
                if let pollenInfo = pollen["latitude"] as? String {
                    pollenLatitude = Double(pollenInfo)!
                }
                if let pollenInfo = pollen["longitude"] as? String {
                    pollenLongitude = Double(pollenInfo)!
                }
              
                let pollen = MGLPointAnnotation()
                pollen.coordinate = CLLocationCoordinate2DMake(pollenLatitude, pollenLongitude)
                //mapView.addAnnotation(pollen)
            }
        }
    }
    
    
    //GRAINE
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {

        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("graine")
        
        if (annotationImage == nil) {
            var image = UIImage(named: "pin-map-green")!
            image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "graine")
        }
        
        return annotationImage
    }
    
    //POLLEN
    
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
  
}




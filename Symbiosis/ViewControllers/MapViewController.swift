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
        var date:NSDate? = NSDate()
        
        let formater = NSDateFormatter()
        formater.dateFormat = "dd/MM/yyyy"
        
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
                if let graineInfo = graine["date"] as? String {

                    if var dateF = formater.dateFromString(graineInfo){
                        dateF = addUnitToDate(.Day, number: +7, date: dateF)
                        date = dateF
                    }
                }
                
                let dateNow = NSDate()
                let compareDateResult = date!.compare(dateNow)
                //if current date > dateformated = AUJOUR > date + 7jours
                if compareDateResult == NSComparisonResult.OrderedDescending{
                    
                    let graineOld = MGLPointAnnotation()
                    graineOld.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    graineOld.title = name
                    mapView.addStyleClass("graineOld")
                    graineOld.subtitle = String("old")
                    mapView.addAnnotation(graineOld)

                }else{
                    let graine = MGLPointAnnotation()
                    graine.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    graine.title = name
                    mapView.addStyleClass("graine")
                    graine.subtitle = String("new")
                    mapView.addAnnotation(graine)
                }
    
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
                mapView.addStyleClass("pollen")
                mapView.addAnnotation(pollen)
            }
        }
    }
    
    
    //GRAINE
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {

        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("graine")
        
        
        for mapStyle in mapView.styleClasses{
            
            if(mapStyle == "graine"){
                //print(mapStyle, "-----")
                var image = UIImage(named: "pin-map-green")!
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "graine")
                mapView.removeStyleClass("graine")
            }
            if(mapStyle == "pollen"){
                //print(mapStyle, "-----")
                var image = UIImage(named: "pollen")!
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pollen")
                mapView.removeStyleClass("pollen")
            }
            if(mapStyle == "graineOld"){
                //print(mapStyle, "-----")
                var image = UIImage(named: "pin-map-yellow")!
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "graineOld")
                mapView.removeStyleClass("graineOld")
            }
        }
        
        return annotationImage
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func addUnitToDate(unitType: NSCalendarUnit, number: Int, date:NSDate) -> NSDate {
        
        return NSCalendar.currentCalendar().dateByAddingUnit(
            unitType,
            value: number,
            toDate: date,
            options: NSCalendarOptions(rawValue: 0))!
    }
    
    
    
}


class MapPopup : MapViewController{

    let background = Background()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("popup")
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.2
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    //add imageview
    //import nav
    //add transition
    
    //NB attention notification ouvre la page voulu
    //if notification or si popup jamais visisté alors tabBar add bullet
    //scoll view for image
    //if distance < x subtitle (or link) = commenter or if > s'y rendre
    //if went in sedd's direction and your position = position of one graine -> push notification vous etes arrivé...
    
}




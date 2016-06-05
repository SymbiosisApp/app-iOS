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

class MapViewController: UIViewController, MGLMapViewDelegate, SYStateListener {
    let request = RequestData()
    
    var myMapView: MGLMapView!
    var geolocPointer: MGLPointAnnotation!
    
    // State
    let state = SYStateManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen to events
        state.addListener(self)
        
        self.myMapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURLWithVersion(9))
        myMapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // set the map’s center coordinate and zoom level
        myMapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 48.853138550976446, longitude: 2.348756790161133), zoomLevel: 12, animated: false)
        
        myMapView.tintColor = .darkGrayColor()
        
        view.addSubview(myMapView)
        myMapView.delegate = self
        
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
                    myMapView.addStyleClass("graineOld")
                    graineOld.subtitle = String("old")
                    myMapView.addAnnotation(graineOld)

                }else{
                    let graine = MGLPointAnnotation()
                    graine.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    graine.title = name
                    myMapView.addStyleClass("graine")
                    graine.subtitle = String("new")
                    myMapView.addAnnotation(graine)
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
                myMapView.addStyleClass("pollen")
                myMapView.addAnnotation(pollen)
            }
        }
        
        //POINTEUR
        self.updateGeoloc()
    }
    
    
    //PIN'S STYLE
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {

        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("graine")
        
        for mapStyle in mapView.styleClasses{
            
            if(mapStyle == "graine"){
                var image = UIImage(named: "pin-map-green")!
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "graine")
                mapView.removeStyleClass("graine")
            }
            if(mapStyle == "pollen"){
                var image = UIImage(named: "pollen")!
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pollen")
                mapView.removeStyleClass("pollen")
            }
            if(mapStyle == "graineOld"){
                var image = UIImage(named: "pin-map-yellow")!
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "graineOld")
                mapView.removeStyleClass("graineOld")
            }
            if(mapStyle == "pointeur"){
                var image = UIImage(named: "pointeur")!
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pointeur")
                mapView.removeStyleClass("pointeur")
            }
        }
        
        return annotationImage
    }
    
    
    //ADD INFORMATIONS FOR ONE PIN
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    /**
     * State Update
     **/
    
    func onStateSetup() {
        
        
        
    }
    
    func onStateUpdate() {
        if state.locationHasChanged() {
            self.myMapView.removeAnnotations([self.geolocPointer])
            self.updateGeoloc()
        }
    }
    
    func updateGeoloc() {
        // print("Update geoloc")
        if self.geolocPointer != nil {
            self.myMapView.removeAnnotations([self.geolocPointer])
        }
        self.geolocPointer = MGLPointAnnotation()
        self.geolocPointer.coordinate = state.getCurrentLocation()
        myMapView.addStyleClass("pointeur")
        myMapView.addAnnotation(geolocPointer)
    }
    
    //ADD DAYS AT ONE DATE
    func addUnitToDate(unitType: NSCalendarUnit, number: Int, date:NSDate) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(
            unitType,
            value: number,
            toDate: date,
            options: NSCalendarOptions(rawValue: 0))!
    }
    
  
}




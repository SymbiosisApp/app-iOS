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

class SeedAnnotation: MGLPointAnnotation {
    
    private var _seed: Seed!
    
    var seed: Seed? {
        set(newSeed) {
            self._seed = newSeed
            self.title = self._seed.name
            self.coordinate = self._seed.coordinate
        }
        get {
            return self._seed
        }
    }
    
    
    var style: String {
        get {
            if self._seed!.isRecent {
                return "graine"
            } else {
                return "graineOld"
            }
        }
    }
    
}


class MapViewController: UIViewController, MGLMapViewDelegate, SYStateListener {
    let request = RequestData()
    
    @IBOutlet weak var mapSuperView: UIView!
    @IBOutlet weak var suggest: UIButton!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var localisation: UIButton!
    
    var myMapView: MGLMapView!
    var geolocPointer: MGLPointAnnotation!
    var selectedAnnotation: MGLAnnotation? = nil
    
    // State
    let state = SYStateManager.sharedInstance
    
    var seedData: [Seed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myMapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.lightStyleURLWithVersion(9))
        //myMapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        myMapView.tintColor = .darkGrayColor()
        
        self.mapSuperView.addSubview(myMapView)
        myMapView.delegate = self
        
        //GRAINE
        let dataMap = request.getData("http://symbiosis.etienne-dldc.fr/graines/")
        var latitude:Double = 0
        var longitude:Double = 0
        var name:String = ""
        var date:NSDate? = NSDate()
        var id: Int? = nil
        
        let formater = NSDateFormatter()
        formater.dateFormat = "dd/MM/yyyy"
        
        // Compute seeds
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
                if let graineInfo = graine["rowid"] as? String {
                    id = Int(graineInfo)!
                }
                if let graineInfo = graine["date"] as? String {
                    if var dateF = formater.dateFromString(graineInfo){
                        dateF = addUnitToDate(.Day, number: +7, date: dateF)
                        date = dateF
                    }
                }
                
                let seed = Seed(coordinate: CLLocationCoordinate2DMake(latitude, longitude), name: name, date: date!, id: id!)
                self.seedData.append(seed)
    
            }
        }
        
        for seed in self.seedData {
            let seedAnot = SeedAnnotation()
            seedAnot.seed = seed
            myMapView.addStyleClass(seedAnot.style)
            myMapView.addAnnotation(seedAnot)
        }
        
        
        //POLLEN
        let pollenDataMap = request.getData("http://symbiosis.etienne-dldc.fr/pollens/")
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
        
        search.layer.zPosition = 1
        localisation.layer.zPosition = 1
        suggest.layer.zPosition = 1
        
        // Listen to events
        state.addListener(self)
        
    }
    
    
    //PIN'S STYLE
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {

        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("graine")
        
        for mapStyle in mapView.styleClasses{
            
            if(mapStyle == "pointeur"){
                var image = UIImage(named: "pointeur")!
                image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pointeur")
                mapView.removeStyleClass("pointeur")
            }
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
        }
        
        return annotationImage
    }
    
    
    //ADD INFORMATIONS FOR ONE PIN
    @IBOutlet weak var colonie: SYColony!

    @IBAction func close(sender: AnyObject) {
        
    }
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(mapView: MGLMapView, didSelectAnnotation annotation: MGLAnnotation) {
        if let seedAnnot = annotation as? SeedAnnotation {
            self.selectedAnnotation = annotation
            state.dispatchAction(SYStateActionType.SelectSeed, payload: seedAnnot.seed)
        }
    }
    
    /**
     * State Update
     **/
    
    func onStateSetup() {
        if state.getSelectedSeed() == nil {
            self.myMapView.removeAnnotations([self.geolocPointer])
            self.updateGeoloc()
            myMapView.deselectAnnotation(nil, animated: true)
        }

    }
    
    func onStateUpdate() {
        if state.locationHasChanged() {
            self.myMapView.removeAnnotations([self.geolocPointer])
            self.updateGeoloc()
        }
        if state.selectedSeedHasChanged() {
            if state.getSelectedSeed() == nil {
                myMapView.deselectAnnotation(self.selectedAnnotation, animated: true)
            }
        }
        
        let showPin = state.allFunctionnalities()
        
        if showPin{
            suggest.hidden = false
            search.hidden = false
            localisation.hidden = false
        }else{
            suggest.hidden = true
            search.hidden = true
            localisation.hidden = true
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
        
        // set the map’s center coordinate and zoom level
        let long = state.getCurrentLocation().longitude
        let lat = state.getCurrentLocation().latitude
        myMapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: long), zoomLevel: 13, animated: true)
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




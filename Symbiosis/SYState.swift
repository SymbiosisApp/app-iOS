//
//  SYState.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 09/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import CoreLocation

struct SYState {
    var selectedTab: Int = 2
    var lastSelectedTab: Int = -1
    var steps: Int = 0
    var plantIsAnimating: Bool = false
    var plantIsGenerating: Bool = false
    var plantProgress: Float = 0
    var nextPlantProgress: Float = 0
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.8746253, longitude: 2.38835662)
    var popups: Array<String?> = [nil, nil, nil, nil, nil]
    var displayedOnboarding: String? = nil
    
    // Temp
    var tabBarHidden: Bool = false
}

class SYStateManager: SYLocationManagerDelegate, SYPedometerDelegate {
    
    private var currentState = SYState()
    private var previousState = SYState()
    
    /**
     * This is the Events part
     **/
    
    static let sharedInstance = SYStateManager()
    
    // Location manager
    let locationManager: SYLocationManager = SYLocationManager(useNatif: false)
    // Pedometer
    let pedometer: SYPedometer = SYPedometer(useNatif: false)
    
    private init() {
        // Delegates
        self.locationManager.delegate = self
        self.pedometer.delegate = self
        
        self.locationManager.start()
    }
    
    var listeners = [SYStateWeakListener]();
    
    func addListener(listener: SYStateListener) {
        let weakListener = SYStateWeakListener(listener: listener)
        self.listeners.append(weakListener)
    }

    func triggerUpdate() {
        // print("Update")
        // Clean listeners
        for (index, listener) in self.listeners.enumerate() {
            if listener.isInMemory() == false {
                self.listeners.removeAtIndex(index)
            }
        }
        
        for listener in self.listeners {
            listener.tryUpdate()
        }
        
        self.previousState = self.currentState
    }
    
    /**
     * State Actions
     * -> Update the state and trigger Update
     **/
    // - MARK: State Actions
    
    func selectTab(newSelectedTab: Int) {
        if newSelectedTab != currentState.selectedTab {
            currentState.lastSelectedTab = currentState.selectedTab
            currentState.selectedTab = newSelectedTab
        }
        self.triggerUpdate()
    }
    
    func setSteps(newSteps: Int) {
        currentState.steps = newSteps
        self.updatePlantProgress()
        self.setPopup("commencer", onTab: 3)
        self.triggerUpdate()
    }
    
    func plantStartAnimate() {
        if self.currentState.plantIsAnimating {
            fatalError("Plant is already animating !")
        }
        self.currentState.plantIsAnimating = true
        self.triggerUpdate()
    }
    
    func setTabBarHidden(newValue: Bool) {
        currentState.tabBarHidden = newValue
        self.triggerUpdate()
    }
    
    func plantEndAnimating() {
        self.currentState.plantIsAnimating = false
        self.triggerUpdate()
    }
    
    func plantStartGenerating() {
        if self.currentState.plantIsGenerating {
            fatalError("Plant is already animating !")
        }
        self.currentState.plantIsGenerating = true
        self.triggerUpdate()
    }
    
    func plantEndGenerating() {
        self.currentState.plantIsGenerating = false
        self.currentState.plantProgress = self.currentState.nextPlantProgress
        self.triggerUpdate()
    }
    
    func updateGeoloc(location: CLLocationCoordinate2D) {
        currentState.location = location
        self.triggerUpdate()
    }
    
    func hideCurrentPopup() {
        let tab = getSelectedTab()
        self.currentState.popups[tab] = nil
        self.triggerUpdate()
    }
    
    func hideOnboarding() {
        currentState.displayedOnboarding = nil
    }
    
    func showOnboarding(name: String) {
        currentState.displayedOnboarding = name
    }
    
    /**
     * State modif tool
     * -> Update the state but don't trigger update
     **/
    
    func updatePlantProgress() {
        let nextProgress = 5 * log10( ( Float(currentState.steps) + 10000 ) / 10000 )
        let diff = abs(nextProgress - currentState.plantProgress)
        if diff > 0.1 {
            currentState.nextPlantProgress = nextProgress
        }
    }
    
    func setPopup(popupName: String, onTab tabIndex: Int) {
        currentState.popups[tabIndex] = popupName
    }
    
    /**
     * Get tools
     * -> Don't change the state, just read it
     **/
    // - MARK: Get special properties
    
    func tabHasChanged() -> Bool {
        return currentState.selectedTab != previousState.selectedTab
    }
    
    func isSelectedTab(index: Int) -> Bool {
        return currentState.selectedTab == index
    }
    
    func isNotifiedTab(index: Int) -> Bool {
        let popup = currentState.popups[index]
        if popup != nil {
            if self.isSelectedTab(index) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func previousIsNotifiedTab(index: Int) -> Bool {
        let popup = previousState.popups[index]
        if popup != nil {
            if previousState.selectedTab == index {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func tabNotificationHasChanged(index: Int) -> Bool {
        return isNotifiedTab(index) != previousIsNotifiedTab(index)
    }
    
    
    func getSelectedTab() -> Int {
        return currentState.selectedTab
    }
    
    func popupHasChanged() -> Bool {
        return self.getCurrentPopup() != self.getPrevioustPopup()
    }
    
    func tabBarIsHidden() -> Bool {
        return currentState.tabBarHidden
    }
    
    func tabBarHiddenHasChanged() -> Bool {
        return currentState.tabBarHidden != previousState.tabBarHidden
    }
    
    func getCurrentPopup() -> String? {
        return self.currentState.popups[self.currentState.selectedTab]
    }
    
    func getPrevioustPopup() -> String? {
        if self.previousState.selectedTab >= 0 {
            return self.previousState.popups[self.previousState.selectedTab]
        } else {
            return nil
        }
        
    }
    
    func getPlantProgresses() -> [Float] {
        return [currentState.plantProgress, currentState.nextPlantProgress]
    }
    
    func getLastSelectedTab() -> Int {
        return currentState.lastSelectedTab
    }
    
    func plantShouldEvolve() -> Bool {
        if currentState.plantIsGenerating {
            return false
        }
        return (currentState.plantProgress != currentState.nextPlantProgress)
    }
    
    func getCurrentTotalSteps() -> Int {
        return currentState.steps
    }
    
    func getPreviousTotalSteps() -> Int {
        return previousState.steps
    }
    
    func plantIsAnimating() -> Bool {
        return false
        // return currentState.plantIsAnimating
    }
    
    func locationHasChanged() -> Bool {
        return (currentState.location.latitude != previousState.location.latitude ||
            currentState.location.longitude != previousState.location.longitude)
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        return currentState.location
    }
    
    func getOnboardingToDisplay() -> String? {
        return nil
        if currentState.displayedOnboarding != nil {
            return nil
        } else {
            return "Graine"
        }
    }
    
    
    
    /**
     * Delegates
     **/
    // - MARK: SYLocationManager Delegate
    
    func syLocationManager(manager: SYLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.updateGeoloc(locations[0].coordinate)
    }
    
    func syLocationManagerDidGetAuthorization(manager: SYLocationManager) {
        print("Location manager Authorisation ok")
    }
    
    // - MARK: SYPedometer Delegate
    
    func syPedometer(didReveiveData data: NSNumber) {
        self.setSteps(Int(data))
    }
    
}

class SYStateWeakListener {
    weak var listener : SYStateListener?
    init (listener: SYStateListener) {
        self.listener = listener
    }
    
    func isInMemory() -> Bool {
        return self.listener != nil
    }
    
    func tryUpdate() {
        if let myListener = self.listener {
            myListener.onStateUpdate()
        }
    }
}

protocol SYStateListener: class {
    func onStateUpdate()
}
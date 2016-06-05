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
    var tab: Int = 3
    var steps: Int = 0
    var plantStatus: SYStatePlantStatus = .NotGenerated
    var plantProgress: Float = 0
    var nextPlantProgress: Float = 0
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.8746253, longitude: 2.38835662)
    var popups: Array<String?> = [nil, nil, nil, nil, nil]
    var displayedOnboarding: String? = nil
    
    // Temp
    var tabBarHidden: Bool = false
}

enum SYStateActionType {
    case SelectTab
    case SetPlantStep
    case SetPlantStatus
    case SetTabBarHidden
    case SetGeoloc
    case HideCurrentPopup
    case ShowOnboarding
    case HideOnboarding
}

enum SYStatePlantStatus {
    case NotGenerated
    case Generating
    case Generated
    case Animating
    case Animated
}

struct SYStateAction {
    let type: SYStateActionType
    let payload: Any?
}

class SYStateManager: SYLocationManagerDelegate, SYPedometerDelegate {
    
    private var currentState = SYState()
    private var previousState = SYState()
    
    private var actionsQueue: [SYStateAction] = []
    private var dequeInProgress: Bool = false
    
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
    
    var listeners = [SYStateListenerWrapper]();
    
    func addListener(listener: SYStateListener) {
        let weakListener = SYStateListenerWrapper(listener: listener)
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
    }
    
    func dequeueActions() {
        dequeInProgress = true
        if actionsQueue.count > 0 {
            let action = self.actionsQueue.removeAtIndex(0)
            // Copy state
            self.previousState = self.currentState
            self.currentState = reducer(currentState, action: action)
            self.triggerUpdate()
            dequeueActions()
        }
        dequeInProgress = false
    }
    
    func dispatchAction(type: SYStateActionType, payload: Any?) {
        let action = SYStateAction(type: type, payload: payload)
        self.actionsQueue.append(action)
        if dequeInProgress == false {
            dequeueActions()
        }
    }
    
    /**
     * Reducer
     * -> Update the state
     * make changes in state
     * you can check value of currentState
     **/
    // - MARK: State Actions
    
    func reducer(previousState: SYState, action: SYStateAction) -> SYState {
        var state = previousState
        let payload = action.payload
        switch action.type {
        case .SelectTab:
            let newSelectedTab = payload as! Int
            if newSelectedTab != state.tab {
                state.tab = newSelectedTab
            }
        case .SetPlantStep:
            let newSteps = payload as! Int
            state.steps = newSteps
            state = self.updatePlantProgress(state)
            state = self.setPopup(state, popupName: "commencer", onTab: 3)
        case .SetPlantStatus:
            let status = payload as! SYStatePlantStatus
            // TODO verif status
//            if status == true && self.currentState.plantIsAnimating {
//                fatalError("Plant is already animating !")
//            }
            state.plantStatus = status
        case .SetTabBarHidden:
            let status = payload as! Bool
            state.tabBarHidden = status
        case .SetGeoloc:
            let newGeoloc = payload as! CLLocationCoordinate2D
            state.location = newGeoloc
        case .HideCurrentPopup:
            let tab = getCurrentTab()
            state.popups[tab] = nil
        case .ShowOnboarding:
            let onboardingName = payload as! String
            state.displayedOnboarding = onboardingName
        case .HideOnboarding:
            state.displayedOnboarding = nil
        }
        return state
    }
    
    /**
     * Sub reducer
     * -> Update the state but don't trigger update
     **/
    
    func updatePlantProgress(state: SYState) -> SYState {
        var state = state
        let nextProgress = 5 * log10( ( Float(currentState.steps) + 10000 ) / 10000 )
        let diff = abs(nextProgress - currentState.plantProgress)
        if diff > 0.1 {
            state.nextPlantProgress = nextProgress
        }
        return state
    }
    
    func setPopup(state: SYState, popupName: String, onTab tabIndex: Int) -> SYState {
        var state = state
        state.popups[tabIndex] = popupName
        return state
    }
    
    /**
     * Get tools
     * -> Don't change the state, just read it
     **/
    // - MARK: Get special properties
    
    func tabHasChanged() -> Bool {
        return currentState.tab != previousState.tab
    }
    
    func isSelectedTab(index: Int) -> Bool {
        return currentState.tab == index
    }
    
    func getCurrentTab() -> Int {
        return currentState.tab
    }
    
    func getPreviousTab() -> Int {
        return previousState.tab
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
            if previousState.tab == index {
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
        return self.currentState.popups[self.currentState.tab]
    }
    
    func getPrevioustPopup() -> String? {
        if self.previousState.tab >= 0 {
            return self.previousState.popups[self.previousState.tab]
        } else {
            return nil
        }
    }
    
    func plantIsGenerating() -> Bool {
        return currentState.plantStatus == .Generating
    }
    
    func getPlantProgresses() -> [Float] {
        return [currentState.plantProgress, currentState.nextPlantProgress]
    }
    
    func plantShouldEvolve() -> Bool {
        if self.plantIsGenerating() {
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
//        if currentState.displayedOnboarding != nil {
//            return nil
//        } else {
//            return "Graine"
//        }
    }
    
    
    
    /**
     * Delegates
     **/
    // - MARK: SYLocationManager Delegate
    
    func syLocationManager(manager: SYLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.dispatchAction(.SetGeoloc, payload: locations[0].coordinate)
    }
    
    func syLocationManagerDidGetAuthorization(manager: SYLocationManager) {
        print("Location manager Authorisation ok")
    }
    
    // - MARK: SYPedometer Delegate
    
    func syPedometer(didReveiveData data: NSNumber) {
        self.dispatchAction(.SetPlantStep, payload: Int(data))
    }
    
}

class SYStateListenerWrapper {
    
    weak var listener : SYStateListener?
    var setUpDone: Bool = false
    
    init (listener: SYStateListener) {
        self.listener = listener
        self.tryUpdate()
    }
    
    func isInMemory() -> Bool {
        return self.listener != nil
    }
    
    func tryUpdate() {
        if let myListener = self.listener {
            if setUpDone {
                myListener.onStateUpdate()
            } else {
                myListener.onStateSetup()
                setUpDone = true
            }
        }
    }
}

protocol SYStateListener: class {
    func onStateUpdate()
    func onStateSetup()
}
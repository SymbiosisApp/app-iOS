//
//  SYState.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 09/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: State Object

enum SYStatePlantStatus {
    case NotGenerated
    case Generating
    case Generated
    case Animating
    case Animated
}

struct SYStateUser {
    var isAuthenticated: Bool = false
    var hasASeed: Bool = false
}

/// The state object
struct SYState {
    var tab: Int = 1
    var steps: Int = 0
    var plant: SYPlant? = nil
    var plantStatus: SYStatePlantStatus = .NotGenerated
    var plantProgress: Float = 0
    var nextPlantProgress: Float? = nil
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.845566, longitude: 2.348988)
    var popups: Array<String?> = [nil, nil, nil, nil, nil]
    var displayedOnboarding: String? = nil
    var onboardingToDisplay: String? = nil
    var user: SYStateUser = SYStateUser()
    var selectedSeed: Seed? = nil
    var loginIsDisplay: Bool = false
    var commentViewIsDisplay: Bool = false
    var unreadMessages: Bool = false
    var appInBackground: Bool = false
    var notificationSended: Bool = false
    
    var prezStep: String = "start"
    var fonctionnalities: Bool = false
}

/// State Actions Type
enum SYStateActionType {
    case SelectTab
    case SetPlantStep
    case SetPlantStatus
    case SetGeoloc
    case HideCurrentPopup
    case ShowOnboarding
    case HideOnboarding
    case SetUserSeed
    case SelectSeed
    case DisplayLogin
    case UpdatePlant
    case SetPlantProgress
    case SetCommentDisplay
    case SetOnboardingToDisplay
    case SetUnreadMessages
    case SetBackgroundMode
    case NotificationSended
}

/// State Action strcut
struct SYStateAction {
    let type: SYStateActionType
    let payload: Any?
}

// - MARK: State manager

class SYStateManager: SYLocationManagerDelegate, SYPedometerDelegate {
    
    private var currentState = SYState()
    private var previousState = SYState()
    
    private var actionsQueue: [SYStateAction] = []
    private var dequeInProgress: Bool = false
    
    // MARK: Redux implementation
    
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
    

    // - MARK: Reducger
    /**
     * -> Update the state
     * make changes in state
     * check value of currentState
     **/
    
    func reducer(previousState: SYState, action: SYStateAction) -> SYState {
        var state = previousState
        print("=> Action : \(action.type)")
        let payload = action.payload
        switch action.type {
        
        case .SelectTab:
            let newSelectedTab = payload as! Int
            if currentState.user.hasASeed == false {
                // Only map is allow if no seed
                state.tab = 1
            } else {
                state.tab = newSelectedTab
            }
        
        case .SetPlantStep:
            let newSteps = payload as! Int
            state.steps = newSteps
        
        case .SetPlantStatus:
            let status = payload as! SYStatePlantStatus
            // TODO verif status
//            if status == true && self.currentState.plantIsAnimating {
//                fatalError("Plant is already animating !")
//            }
            state.plantStatus = status
        
        case .SetGeoloc:
            let newGeoloc = payload as! CLLocationCoordinate2D
            state.location = newGeoloc
        
        case .HideCurrentPopup:
//            if let popup = self.getCurrentPopup() {
//                if popup == "colony" {
//                    state.displayedOnboarding = "Graine"
//                }
//            }
            let tab = getCurrentTab()
            state.popups[tab] = nil
        
        case .SetOnboardingToDisplay:
            let onboardingName = payload as! String
            state.onboardingToDisplay = onboardingName
            
        case .ShowOnboarding:
            let onboardingName = payload as! String
            state.displayedOnboarding = onboardingName
            state.onboardingToDisplay = nil
        
        case .HideOnboarding:
            if currentState.displayedOnboarding == "Intro" {
                state.prezStep = "yolo"
                state = self.setPopup(state, popupName: "commencer", onTab: 1)
            }
            if currentState.displayedOnboarding == "Graine" {
                self.dispatchAction(SYStateActionType.SetUnreadMessages, payload: true)
            }
            state.displayedOnboarding = nil

        case .SetUserSeed:
            state.user.hasASeed = true
        
        case .SelectSeed:
            if let seed = payload as? Seed {
                state.selectedSeed = seed
            } else {
                state.selectedSeed = nil
            }
            state = updateMapPopup(state)
        
        case .DisplayLogin:
            state.loginIsDisplay = true
        
        case .UpdatePlant:
            let newPlant = payload as! SYPlant
            state.plant = newPlant
        
        case .SetPlantProgress:
            let newProgress = payload as! Float
            state.plantProgress = newProgress
            state.nextPlantProgress = nil
            
        case .SetCommentDisplay:
            let display = payload as! Bool
            state.commentViewIsDisplay = display
            
        case .SetUnreadMessages:
            let hasUnread = payload as! Bool
            state.unreadMessages = hasUnread
            
        case .SetBackgroundMode:
            let back = payload as! Bool
            if back == false {
                state.notificationSended = false
            }
            state.appInBackground = back
            
        case .NotificationSended:
            state.notificationSended = true
        }
        state = self.updatePlant(state)
        return state
    }
    
    // MARK: Sub-reducers
    /**
     * Sub reducer
     * -> Update the state but don't trigger update
     **/
    
    func updatePlant(state: SYState) -> SYState {
        var state = state
        // Update progress
        if currentState.user.hasASeed == false {
            // if no seed Do nothing because no plant :)
            return state
        }
        if state.plantStatus == .Generating {
            return state
        }
        var nextProgress = 5 * log10( ( Float(currentState.steps) + 10000 ) / 10000 )
        nextProgress += 0.6 // Pouce size
        let diff = abs(nextProgress - currentState.plantProgress)
        if diff > 0.1 {
            print("Generate Plant !")
            state.plantStatus = .Generating
            // Save nextProgress
            state.nextPlantProgress = nextProgress
            // Generate plant for currentState.plantProgress => nextProgress
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dispatchAction(SYStateActionType.SetPlantStatus, payload: SYStatePlantStatus.Generating)
                }
                let nextPlant = SYPlant(progresses: [self.previousState.plantProgress, nextProgress])
                dispatch_async(dispatch_get_main_queue()) {
                    self.dispatchAction(SYStateActionType.SetPlantProgress, payload: nextProgress)
                    self.dispatchAction(SYStateActionType.UpdatePlant, payload: nextPlant)
                    self.dispatchAction(SYStateActionType.SetPlantStatus, payload: SYStatePlantStatus.Generated)
                }
            }
            
//            let blocksDispatchQueue = dispatch_queue_create("com.domain.blocksArray.sync", DISPATCH_QUEUE_CONCURRENT)
//            dispatch_sync(blocksDispatchQueue) {
//                self.dispatchAction(SYStateActionType.SetPlantStatus, payload: SYStatePlantStatus.Generating)
//                let nextPlant = SYPlant(progresses: [self.previousState.plantProgress, nextProgress])
//                self.dispatchAction(SYStateActionType.SetPlantProgress, payload: nextProgress)
//                self.dispatchAction(SYStateActionType.UpdatePlant, payload: nextPlant)
//                self.dispatchAction(SYStateActionType.SetPlantStatus, payload: SYStatePlantStatus.Generated)
//            }
        }
        return state
    }
    
    func setPopup(state: SYState, popupName: String, onTab tabIndex: Int) -> SYState {
        var state = state
        state.popups[tabIndex] = popupName
        return state
    }
    
    func updateMapPopup(state: SYState) -> SYState {
        var state = state
        if state.selectedSeed != nil {
            state.popups[1] = "colony"
        }
        return state
    }
    
    // - MARK: Read State
    /**
     * -> Don't change the state, just read it
     **/
    
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
        return isNotifiedTabForState(currentState, index: index)
    }
    
    func previousIsNotifiedTab(index: Int) -> Bool {
        return isNotifiedTabForState(previousState, index: index)
    }
    
    private func isNotifiedTabForState(state: SYState, index: Int) -> Bool {
        if state.tab == index {
            return false
        }
        if index == 2 && state.plantStatus == .Generated {
            return true
        }
        if index == 3 && state.unreadMessages == true { // Chat
            return true
        }
        let popup = state.popups[index]
        if popup != nil {
            return true
        }
        return false
    }
    
    func tabNotificationHasChanged(index: Int) -> Bool {
        return isNotifiedTab(index) != previousIsNotifiedTab(index)
    }
    
    func popupHasChanged() -> Bool {
        return self.getCurrentPopup() != self.getPrevioustPopup()
    }
    
    func tabBarIsDisplayed() -> Bool {
        return currentState.user.hasASeed != false
    }
    
    func userHasSeed() -> Bool {
        return currentState.user.hasASeed
    }
    
    func previousTabBarIsDisplayed() -> Bool {
        return previousState.user.hasASeed != false
    }
    
    func tabBarDisplayHasChanged() -> Bool {
        return tabBarIsDisplayed() != previousTabBarIsDisplayed()
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

    func getPlantStatus() -> SYStatePlantStatus {
        return currentState.plantStatus
    }
    
    func plantStatusHasChanged() -> Bool {
        return currentState.plantStatus != previousState.plantStatus
    }
    
    func getPlant() -> SYPlant? {
        return currentState.plant
    }
    
    func getCurrentTotalSteps() -> Int {
        return currentState.steps
    }
    
    func getPreviousTotalSteps() -> Int {
        return previousState.steps
    }
    
    func locationHasChanged() -> Bool {
        return (currentState.location.latitude != previousState.location.latitude ||
            currentState.location.longitude != previousState.location.longitude)
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        return currentState.location
    }
    
    func getProgressBarProgress() -> Float {
        return (Float(currentState.steps) % 10001) / 10000
    }
    
    func getOnboardingToDisplay() -> String? {
        if currentState.onboardingToDisplay != previousState.onboardingToDisplay && currentState.onboardingToDisplay != nil {
            return currentState.onboardingToDisplay!
        }
        if currentState.displayedOnboarding != nil {
            return nil
        }
        if currentState.prezStep == "start" {
            return "Intro"
        }
        return nil
    }
    
    func selectedSeedHasChanged() -> Bool {
        if currentState.selectedSeed == nil && previousState.selectedSeed == nil {
            return false
        }
        if currentState.selectedSeed != nil && previousState.selectedSeed == nil {
            return true
        }
        if currentState.selectedSeed == nil && previousState.selectedSeed != nil {
            return true
        }
        // Both not nil
        return currentState.selectedSeed!.id != previousState.selectedSeed!.id
    }
    
    func distanceToSelectedSeed() -> Double? {
        if currentState.selectedSeed == nil {
            return nil
        }
        let from = CLLocation(latitude: currentState.location.latitude, longitude: currentState.location.longitude)
        let to = CLLocation(latitude: currentState.selectedSeed!.coordinate.latitude, longitude: currentState.selectedSeed!.coordinate.longitude)
        return from.distanceFromLocation(to)
    }
    
    func getSelectedSeed() -> Seed? {
        return currentState.selectedSeed
    }
    
    func commentDisplayHasChanged() -> Bool {
        return currentState.commentViewIsDisplay != previousState.commentViewIsDisplay
    }
    
    func commentIsDisplay() -> Bool {
        return currentState.commentViewIsDisplay
    }
    
    func backgroundModeHasChanged() -> Bool {
        return currentState.appInBackground != previousState.appInBackground
    }
    
    func isInBackgroundMode() -> Bool {
        return currentState.appInBackground
    }
    
    func userIsAuthenticated() -> Bool {
        // TODO join user and state
//        let user = UserSingleton.sharedInstance;
//        if(user.getUserData()["userId"] == nil){
//            
//        }
        return currentState.user.isAuthenticated
    }
    
    func hasNotifToSend() -> Bool {
        if currentState.appInBackground == false {
            return false
        }
        if currentState.notificationSended == true {
            return false
        }
        var result = false
        for i in 0..<currentState.popups.count {
            if currentState.popups[i] != previousState.popups[i] && currentState.popups[i] != nil  {
                result = true
            }
        }
        if result == false {
            if currentState.plantStatus == .Generated {
                result = true
            }
        }
        return result
    }
    
    func allFunctionnalities() -> Bool {
        return currentState.steps > 20000
    }
    
//    func allFunctionnalitiesHasChanged() -> Bool{
//        return currentState.fonctionnalities != previousState.fonctionnalities
//    }
    
    
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
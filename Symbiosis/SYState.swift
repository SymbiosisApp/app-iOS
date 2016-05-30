//
//  SYState.swift
//  symbiosis-ios-app
//
//  Created by Etienne De Ladonchamps on 09/05/2016.
//  Copyright © 2016 Etienne De Ladonchamps. All rights reserved.
//

import Foundation
import CoreLocation

/// Steps struct
struct SYStateSteps {
    let date: NSDate
    let steps: Int
}

struct SYStatePlant {
    let values: [Float]
}

struct SYState {
    var selectedTab: Int = -1
    var lastSelectedTab: Int = -1
    var nextOnboarding: String = "Intro"
    var onboardingOpen: Bool = false
    var steps: [SYStateSteps] = []
    var plantIsAnimating: Bool = false
}

/// Events types
enum SYStateEvent {
    case Update
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
    } //This prevents others from using the default '()' initializer for this class.
    
    // - MARK: EventManager
    
    // using NSMutableArray as Swift arrays can't change size inside dictionaries (yet, probably)
    var listeners = Dictionary<SYStateEvent, NSMutableArray>();
    
    // Create a new event listener, not expecting information from the trigger
    // + eventName: Matching trigger eventNames will cause this listener to fire
    // + action: The block of code you want executed when the event triggers
    func listenTo(event:SYStateEvent, action:(()->())) {
        let newListener = EventListenerAction(callback: action);
        addListener(event, newEventListener: newListener);
    }
    
    internal func addListener(event:SYStateEvent, newEventListener:EventListenerAction) {
        if let listenerArray = self.listeners[event] {
            // action array exists for this event, add new action to it
            listenerArray.addObject(newEventListener);
        }
        else {
            // no listeners created for this event yet, create a new array
            self.listeners[event] = [newEventListener] as NSMutableArray;
        }
    }
    
    // Removes all listeners by default, or specific listeners through paramters
    // + eventName: If an event name is passed, only listeners for that event will be removed
    func removeListeners(eventToRemoveOrNil:SYStateEvent?) {
        if let eventNameToRemove = eventToRemoveOrNil {
            // remove listeners for a specific event
            
            if let actionArray = self.listeners[eventNameToRemove] {
                // actions for this event exist
                actionArray.removeAllObjects();
            }
        }
        else {
            // no specific parameters - remove all listeners on this object
            self.listeners.removeAll(keepCapacity: false);
        }
    }
    
    // Triggers an event
    // + eventName: Matching listener eventNames will fire when this is called
    // + information: pass values to your listeners
    func trigger(event:SYStateEvent, information:Any? = nil) {
        if let actionObjects = self.listeners[event] {
            for actionObject in actionObjects {
                if let actionToPerform = actionObject as? EventListenerAction {
                    if let methodToCall = actionToPerform.actionExpectsInfo {
                        methodToCall(information);
                    }
                    else if let methodToCall = actionToPerform.action {
                        methodToCall();
                    }
                }
            }
        }
    }
    
    
    
    
    func triggerUpdate() {
        self.trigger(.Update)
        print("=======> Replace states")
        self.previousState = self.currentState
        print("=> After Replace states")
    }
    
    
    /**
     * Get special properties
     **/
    // - MARK: Get special properties
    
    func tabHasChanged() -> Bool {
        return currentState.selectedTab != previousState.selectedTab
    }
    
    func isSelectedTab(index: Int) -> Bool {
        return currentState.selectedTab == index
    }
    
    func getSelectedTab() -> Int {
        return currentState.selectedTab
    }
    
    func getLastSelectedTab() -> Int {
        return currentState.lastSelectedTab
    }
    
    func plantShouldAnimate() -> Bool {
        if currentState.plantIsAnimating {
            return false
        }
        return getCurrentTotalSteps() != getPreviousTotalSteps()
    }
    
    func getCurrentTotalSteps() -> Int {
        var result: Int = 0
        for step in self.currentState.steps {
            result += step.steps
        }
        return result
    }
    
    func getPreviousTotalSteps() -> Int {
        var result: Int = 0
        for step in self.previousState.steps {
            result += step.steps
        }
        return result
    }
    
    func plantIsAnimating() -> Bool {
        return currentState.plantIsAnimating
    }
    
    
    
    /**
     * State Actions
     **/
    // - MARK: State Actions
    
    func selectTab(newSelectedTab: Int) {
        if newSelectedTab != currentState.selectedTab {
            currentState.lastSelectedTab = currentState.selectedTab
            currentState.selectedTab = newSelectedTab
        }
        self.triggerUpdate()
    }
    
    func addSteps(newSteps: Int) {
        print("Add steps")
        currentState.steps.append(SYStateSteps(date: NSDate(), steps: newSteps))
        self.triggerUpdate()
    }
    
    func plantStartAnimate() {
        if self.currentState.plantIsAnimating {
            fatalError("Plant is already animating !")
        }
        self.currentState.plantIsAnimating = true
        self.triggerUpdate()
    }
    
    func plantEndAnimating() {
        self.currentState.plantIsAnimating = false
        self.triggerUpdate()
    }
    
    
    
    /**
     * Delegates
     **/
    // - MARK: SYLocationManager Delegate
    
    func syLocationManager(manager: SYLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated !")
        // self.trigger(.ShowOnboarding)
    }
    
    func syLocationManagerDidGetAuthorization(manager: SYLocationManager) {
        print("Location manager Authorisation ok")
    }
    
    // - MARK: SYPedometer Delegate
    
    func syPedometer(didReveiveData data: NSNumber) {
        self.addSteps(Int(data))
    }
    
}

// Class to hold actions to live in NSMutableArray
class EventListenerAction {
    let action:(() -> ())?;
    let actionExpectsInfo:((Any?) -> ())?;
    
    init(callback:(() -> ())) {
        self.action = callback;
        self.actionExpectsInfo = nil;
    }
    
    init(callback:((Any?) -> ())) {
        self.actionExpectsInfo = callback;
        self.action = nil;
    }
}
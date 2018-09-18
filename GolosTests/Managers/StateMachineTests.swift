//
//  StateMachineTests.swift
//  GolosTests
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import XCTest
//@testable import Golos

let userDefaultsMockSuitName = "MockUserDefaults"

class StateMachineTests: XCTestCase {
    
//    var mockUserDefaults: UserDefaults!
//    
//    override func setUp() {
//        super.setUp()
//        
//        UserDefaults().removePersistentDomain(forName: userDefaultsMockSuitName)
//        mockUserDefaults = UserDefaults(suiteName: userDefaultsMockSuitName)
//    }
//    
//    
//    // MARK: Init tests
//    func testCorrectStateAfterInit() {
//        let state = AppState.loggedIn
//        mockUserDefaults.set(state.rawValue, forKey: StateMachine.appStateKey)
//        
//        let stateMachine = StateMachine.load(mockUserDefaults)
//        XCTAssertEqual(state, stateMachine.state,
//                       "State machine must have state that saved in User Defaults after init")
//    }
//    
//    func testSameStateWithSameUserDefaults() {
//        let state = AppState.loggedIn
//        mockUserDefaults.set(state.rawValue, forKey: StateMachine.appStateKey)
//        
//        let stateMachine1 = StateMachine.load(mockUserDefaults)
//        let stateMachine2 = StateMachine.load(mockUserDefaults)
//        
//        XCTAssertEqual(stateMachine1.state, stateMachine2.state,
//                       "State machines loaded with same user defaults must have equal states")
//    }
//    
//    
//    // MARK: State Machine synch
//    func testStateMachineInstancesWithSameUserDefaultsSynch() {
//        let stateMachine1 = StateMachine.load(mockUserDefaults)
//        stateMachine1.changeState(.loggedOut)
//        let stateMachine2 = StateMachine.load(mockUserDefaults)
//        stateMachine2.changeState(.loggedOut)
//        
//        let state = AppState.loggedIn
//        
//        stateMachine1.changeState(state)
//        
//        XCTAssertEqual(stateMachine1.state, stateMachine2.state,
//                       "State in two instances of StateMachine loaded with same User Defaults must be equal after chaging one instance state")
//    }
//    
//    
//    // MARK: State change tests
//    func testValidityToEnterLoggedInStateAfterLoggedOut() {
//        let state = AppState.loggedOut
//        mockUserDefaults.set(state.rawValue, forKey: StateMachine.appStateKey)
//        
//        let stateMachine = StateMachine.load(mockUserDefaults)
//        
//        let isValid = stateMachine.isValidState(AppState.loggedIn)
//        
//        XCTAssertTrue(isValid,
//                       "Entering logged in state from loggedOut state is forbidden")
//    }
//    
//    func testValidityToEnterLoggedOutStateAfterLoggedIn() {
//        let state = AppState.loggedIn
//        mockUserDefaults.set(state.rawValue, forKey: StateMachine.appStateKey)
//        
//        let stateMachine = StateMachine.load(mockUserDefaults)
//        
//        let isValid = stateMachine.isValidState(AppState.loggedOut)
//        
//        XCTAssertTrue(isValid,
//                       "Entering logged in state from loggedOut state is forbidden")
//    }
//    
}

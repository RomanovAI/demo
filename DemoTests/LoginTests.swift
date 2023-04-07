//
//  LoginTests.swift
//  Demo
//
//  Created by Артем Романов on 23.03.2023.
//

import XCTest
import ComposableArchitecture
@testable import Demo

@MainActor
final class LoginTests: XCTestCase {
    
    typealias TestStoreSignature = TestStore<LoginStore.State, LoginStore.Action, LoginStore.State, LoginStore.Action, ()>
    
    func createStore() -> TestStoreSignature {
        TestStore(
            initialState: LoginStore.State.initialState,
            reducer: LoginStore()
        )
    }
    
    func testSuccessCredentials() async {
        let store = createStore()
        
        await store.send(.loginTextChanged(login: "User")) {
            $0.login = DefaultCredentials.successLogin
        }
        await store.send(.passwordTextChanged(password: "123")) {
            $0.password = DefaultCredentials.successPassword
        }
        
    }
    
    func testSuccessIsAvailableButton() async {
        let store = createStore()
        
        await store.send(.loginTextChanged(login: "1")) {
            $0.login = "1"
        }
        
        await store.send(.passwordTextChanged(password: "a")) {
            $0.password = "a"
        }
        
        XCTAssertTrue(store.state.isAvailableButton)
        
    }
    
    func testSuccessIsNotAvailableButton() async {
        let store = createStore()
        
        await store.send(.loginTextChanged(login: ""))
        await store.send(.passwordTextChanged(password: ""))
        
        XCTAssertFalse(store.state.isAvailableButton)
        
    }
    
    func testShowAlert() async {
        let store = createStore()
        
        await store.send(.buttonTapped) {
            $0.error =
            """
            Incorrect login
            Incorrect password
            """
        }
        
        await store.receive(.showAlert) {
            $0.alert = AlertState {
                TextState("Error")
            } actions: {
                ButtonState(
                    role: .cancel,
                    action: .alertDismissed
                ) {
                    TextState("Ok")
                }
            } message: { [error = $0.error] in
                TextState(error)
            }
        }
        
    }
    
    func testGoNextPossibly() async {
        let store = TestStore(
            initialState: LoginStore.State(
                login: DefaultCredentials.successLogin,
                password: DefaultCredentials.successPassword,
                error: ""
            ),
            reducer: LoginStore()
        )
        
        await store.send(.buttonTapped)
        await store.receive(.goNext)
    }
    
}

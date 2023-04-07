//
//  LoginState.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import ComposableArchitecture

// MARK: - State

extension LoginStore {
    
    struct State: Equatable {
        
        static let initialState = State(
            login: .init(),
            password: .init(),
            error: .init()
        )
        
        var login: String
        var password: String
        var error: String
        var alert: AlertState<Action>?
        
        var isAvailableButton: Bool {
            !login.isEmpty && !password.isEmpty
        }
        
    }
    
}

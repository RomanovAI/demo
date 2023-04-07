//
//  LoginStore.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import ComposableArchitecture

struct LoginStore: ReducerProtocol {
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .loginTextChanged(let login):
            state.login = login
            return .none
            
        case .passwordTextChanged(let password):
            state.password = password
            return .none
            
        case .buttonTapped:
            return .merge(validate(&state))
            
        case .showAlert:
            state.alert = createAlert(state)
            return .none
            
        case .alertDismissed:
            state.alert = nil
            state.error = .init()
            return .none
            
        case .goNext:
            return .none
        }
        
    }
    
    // MARK: - private methods
    
    private func validate(_  state: inout State) -> [EffectTask<Action>] {
        var effects: [EffectTask<Action>] = .init()
        
        if state.login != DefaultCredentials.successLogin {
            state.error = "Incorrect login"
        }
        
        if state.password != DefaultCredentials.successPassword {
            state.error += "\nIncorrect password"
        }
        
        if !state.error.isEmpty {
            effects.append(.init(value: .showAlert))
        }
        
        if effects.isEmpty {
            effects.append(.init(value: .goNext))
        }
        
        return effects
    }
    
    private func createAlert(_ state: State) -> AlertState<Action> {
        AlertState {
            TextState("Error")
        } actions: {
            ButtonState(
                role: .cancel,
                action: .alertDismissed
            ) {
                TextState("Ok")
            }
        } message: { [error = state.error] in
            TextState(error)
        }
    }
    
}

struct DefaultCredentials {
    static let successLogin: String = "User"
    static let successPassword: String = "123"
}

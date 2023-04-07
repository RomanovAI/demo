//
//  LoginAction.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

extension LoginStore {
    
    enum Action: Equatable {
        case loginTextChanged(login: String)
        case passwordTextChanged(password: String)
        case buttonTapped
        case goNext
        
        case showAlert
        case alertDismissed
    }
    
}

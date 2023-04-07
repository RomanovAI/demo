//
//  LoginScreen.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import SwiftUI
import ComposableArchitecture

struct LoginScreen: View {
    
    typealias Store = ViewStore<LoginStore.State, LoginStore.Action>
    
    let store: StoreOf<LoginStore>
    
    // MARK: - Body
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 30) {
                image
                
                makeLogin(with: viewStore)
                
                makePassword(with: viewStore)
                
                Spacer()
                
                makeButton(with: viewStore)
                
            }
            .defaultPadding()
            .alert(
                store.scope(state: \.alert),
                dismiss: .alertDismissed
            )
        }
    }
    
    // MARK: - Image
    
    private var image: some View {
        Image("imgLogin")
            .resizable()
            .frame(width: 200, height: 200)
    }
    
    // MARK: - Login
    
    private func makeLogin(with viewStore: Store) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Login")
                .font(.headline)
                .foregroundColor(.black)
            
            StandardTextField(
                placeholder: DefaultCredentials.successLogin,
                text: .init(
                    get: { viewStore.login },
                    set: { viewStore.send(.loginTextChanged(login: $0)) }
                )
            )
        }
    }
    
    // MARK: - Password
    
    private func makePassword(with viewStore: Store) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Password")
                .font(.headline)
                .foregroundColor(.black)
            
            StandardTextField(
                placeholder: DefaultCredentials.successPassword,
                text: .init(
                    get: { viewStore.password },
                    set: { viewStore.send(.passwordTextChanged(password: $0)) }
                )
            )
        }
    }
    
    // MARK: - Button
    
    private func makeButton(with viewStore: Store) -> some View {
        StandardButton(
            text: "Login",
            isAvailable: viewStore.isAvailableButton
        ) {
            viewStore.send(.buttonTapped)
        }
        .disabled(!viewStore.isAvailableButton)
    }
    
}

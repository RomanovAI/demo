//
//  TabBarStore.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import ComposableArchitecture

struct TabBarStore: ReducerProtocol {
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectedTab:
                if state.selectedTab == .login {
                    state.selectedTab = .profile
                } else if state.selectedTab == .profile {
                    state.selectedTab = .login
                }
                return .none
            default:
                return .none
            }
        }
        Scope(state: \.login, action: /TabBarStore.Action.login) {
            LoginStore()
        }
        
        Scope(state: \.profile, action: /TabBarStore.Action.profile) {
            ProfileStore()
        }
    }
}

// MARK: - State

extension TabBarStore {
    
    struct State: Equatable {
        
        static let initialState = State(
            login: .initialState,
            profile: .initialState
        )
        
        var login: LoginStore.State
        var profile: ProfileStore.State
        
        var selectedTab: Tab = .login
        
        enum Tab: String, Equatable {
            case login
            case profile
        }
    }
    
}

// MARK: - Action

extension TabBarStore {
    
    enum Action: Equatable {
        case selectedTab
        
        case login(LoginStore.Action)
        case profile(ProfileStore.Action)
    }
}

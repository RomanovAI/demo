//
//  TabBarView.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import SwiftUI
import ComposableArchitecture

struct TabBarView: View {
    
    let store: StoreOf<TabBarStore>
    
    // MARK: - Body
    
    var body: some View {
        WithViewStore(
            store, observe: \.selectedTab
        ) { viewStore in
            TabView(selection: viewStore.binding(send: .selectedTab)) {
                
                LoginScreen(store: store.scope(
                    state: \.login,
                    action: TabBarStore.Action.login
                ))
                .tabItem {
                    createTabItem(with: .login)
                }
                .tag(TabBarStore.State.Tab.login)
                
                ProfileScreen(store: store.scope(
                    state: \.profile,
                    action: TabBarStore.Action.profile
                ))
                .tabItem {
                    createTabItem(with: .profile)
                }
                .tag(TabBarStore.State.Tab.profile)
                
            }
        }
    }
    
    // MARK: - Private methods
    
    private func createTabItem(with tab: TabBarStore.State.Tab) -> some View {
        VStack {
            Text(tab.rawValue.capitalized)
                .font(.caption)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(store: .init(
            initialState: .initialState,
            reducer: TabBarStore()
        ))
    }
}

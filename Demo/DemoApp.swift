//
//  DemoApp.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import SwiftUI

@main
struct DemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabBarView(store: .init(
                initialState: .initialState,
                reducer: TabBarStore()
                    ._printChanges()
            ))
        }
    }
}

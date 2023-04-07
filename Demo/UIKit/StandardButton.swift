//
//  StandardButton.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import SwiftUI

struct StandardButton: View {
    
    let text: String
    var isAvailable: Bool
    let action: () ->  Void
    
    init(
        text: String,
        isAvailable: Bool = true,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.isAvailable = isAvailable
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
                    .frame(width: 300, height: 50)
                
                Text(text)
                    .foregroundColor(.white)
            }
            .opacity(isAvailable ? 1 : 0.6)
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
}


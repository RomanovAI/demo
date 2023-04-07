//
//  StandardTextField.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import SwiftUI

struct StandardTextField: View {
    
    var placeholder: String
    @Binding var text: String
    var borderColor: Color = .gray
    var borderWidth: CGFloat = 1
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        TextField(
            placeholder,
            text: $text
        )
        .font(.body)
        .foregroundColor(.black)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    borderColor,
                    lineWidth: borderWidth
                )
        )
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

//
//  String+PhoneFormatter.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import Foundation

extension String {
    
    func format(with mask: String) -> String {
        let numbers = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
}

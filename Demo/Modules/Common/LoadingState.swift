//
//  LoadingState.swift
//  Demo
//
//  Created by Артем Романов on 24.03.2023.
//

enum LoadingState: Equatable {
    case loaded
    case loading
    
    var isLoading: Bool { self == .loading }
}

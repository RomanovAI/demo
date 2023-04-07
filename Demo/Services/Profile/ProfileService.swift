//
//  ProfileService.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import ComposableArchitecture
import Dependencies

struct ProfileService {
    
    var fetch: @Sendable () async throws -> ProfileResponseModel
    
}

extension ProfileService: DependencyKey {
    
    static let liveValue = Self(
        fetch: {
            do {
                let time: UInt64 = Bool.random() ? 1_000_000_000 : 3_000_000_000
                try await Task.sleep(nanoseconds: time)
                return .init(
                    id: "32357872",
                    firstName: "John",
                    lastName: "Doe",
                    phone: "79156654321",
                    email: "JohnDoe@gmail.com"
                )
            } catch {
                throw error
            }
        }
    )
    
    static let testValue = Self(
        fetch: unimplemented("\(Self.self).fetch")
    )
    
}

extension DependencyValues {
    
    var profileService: ProfileService {
        get { self[ProfileService.self] }
        set { self[ProfileService.self] = newValue }
    }
    
}

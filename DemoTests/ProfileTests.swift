//
//  ProfileTests.swift
//  DemoTests
//
//  Created by Артем Романов on 24.03.2023.
//

import XCTest
import ComposableArchitecture
@testable import Demo

@MainActor
final class ProfileTests: XCTestCase {
    
    typealias TestStoreSignature = TestStore<ProfileStore.State, ProfileStore.Action, ProfileStore.State, ProfileStore.Action, ()>
    
    func createStore() -> TestStoreSignature {
        TestStore(
            initialState: ProfileStore.State.initialState,
            reducer: ProfileStore()
        )
    }
    
    func testSuccessfulProfileLoading() async {
        let response: ProfileResponseModel = .init(
            id: "32357872",
            firstName: "John",
            lastName: "Doe",
            phone: "79156654321",
            email: "JohnDoe@gmail.com"
        )
        
        let store = TestStore(
            initialState: ProfileStore.State.initialState,
            reducer: ProfileStore()
        ) {
            $0.profileService.fetch = { response }
        }
        
        await store.send(.onAppear)
        await store.receive(.receiveProfileResponse(.success(response))) {
            $0.loadingState = .loaded
            $0.status = .authorized
            $0.name = "\(response.firstName) \(response.lastName)"
            $0.phoneModel.subtitle = response.phone.format(with: "+X XXX XX XXX XX")
            $0.emailModel.subtitle = response.email
            $0.lifetimeId = response.id
        }
        
    }
    
    func testFailureProfileLoading() async {
        let error = NSError()
        let store = TestStore(
            initialState: ProfileStore.State.initialState,
            reducer: ProfileStore()
        ) {
            $0.profileService.fetch = { throw error }
        }
        
        await store.send(.onAppear)
        await store.receive(.receiveProfileResponse(.failure(error))) {
            $0.loadingState = .loaded
            $0.status = .unauthorized
        }
        
    }
    
}

//
//  ProfileStore.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import ComposableArchitecture

struct ProfileStore: ReducerProtocol {
    
    @Dependency(\.profileService) private var profileService
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppear:
            state.loadingState = .loading
            state.status = .unauthorized
            return .task {
                await .receiveProfileResponse(TaskResult { try await profileService.fetch() })
            }
            
        case .logout:
            state.status = .unauthorized
            return .none
            
        case .receiveProfileResponse(.success(let profileModel)):
            state.loadingState = .loaded
            state.status = .authorized
            state.name = "\(profileModel.firstName) \(profileModel.lastName)"
            state.phoneModel.subtitle = profileModel.phone.format(with: "+X XXX XX XXX XX")
            state.emailModel.subtitle = profileModel.email
            state.lifetimeId = profileModel.id
            return .none
            
        case .receiveProfileResponse(.failure(_)):
            state.loadingState = .loaded
            state.status = .unauthorized
            return .none
            
        case .deleteAccount:
            state.alert = createAlert(state)
            return .none
            
        case .alertDismissed:
            state.alert = nil
            state.status = .unauthorized
            return .none
            
        case .confirmationDialogButtonTapped:
            state.confirmationDialog = createConfirmationDialog(state)
            return .none
            
        case .confirmationDialogDismissed:
            state.confirmationDialog = nil
            return .none
        }
    }
    
    // MARK: - Private methods
    
    private func createAlert(_ state: State) -> AlertState<Action> {
        AlertState {
            TextState("Success")
        } actions: {
            ButtonState(
                role: .cancel,
                action: .alertDismissed
            ) {
                TextState("Ok")
            }
        } message: {
            TextState("Your account has been deleted")
        }
    }
    
    private func createConfirmationDialog(_ state: State) -> ConfirmationDialogState<Action> {
        ConfirmationDialogState {
            TextState("Are you sure you want to delete account?")
        } actions: {
            ButtonState(
                role: .destructive,
                action: .deleteAccount
            ) {
                TextState("Delete")
            }
            
            ButtonState(
                role: .cancel,
                action: .confirmationDialogDismissed
            ) {
                TextState("Cancel")
            }
            
        } message: {
            TextState("Are you sure you want to delete account?")
        }
    }
    
}

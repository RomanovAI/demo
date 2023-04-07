//
//  ProfileState.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import Foundation
import ComposableArchitecture

extension ProfileStore {
    
    struct State: Equatable {
        
        static let initialState = State(
            status: .unauthorized,
            loadingState: .loading,
            name: .init(),
            phoneModel:.init(infoType: .phone),
            emailModel: .init(infoType: .email),
            lifetimeId: .init()
        )
        
        enum Status {
            case unauthorized
            case authorized
        }
        
        var status: Status
        var loadingState: LoadingState
        var name: String
        var phoneModel: PersonalInfoModel
        var emailModel: PersonalInfoModel
        var lifetimeId: String
        
        var alert: AlertState<Action>?
        var confirmationDialog: ConfirmationDialogState<Action>?
        
        var infoModels: [PersonalInfoModel] {
            [
                phoneModel,
                emailModel
            ]
        }
        
        var isAuthorized: Bool {
            status == .authorized
        }
        
    }
    
}

// MARK: - PersonalInfoModel

extension ProfileStore.State {
    
    struct PersonalInfoModel: Hashable {
        
        enum InfoType: Equatable {
            case phone
            case email
        }
        
        let title: String
        let iconName: String
        var subtitle: String?
        
        init(infoType: InfoType) {
            switch infoType {
            case .phone:
                self.title = "Phone number"
                self.iconName = "icPhone"
            case .email:
                self.title = "Email"
                self.iconName = "icMail"
            }
        }
    }
    
}

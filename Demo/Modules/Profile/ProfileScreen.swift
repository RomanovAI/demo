//
//  ProfileScreen.swift
//  Demo
//
//  Created by Артем Романов on 22.03.2023.
//

import SwiftUI
import ComposableArchitecture

struct ProfileScreen: View {
    
    typealias Store = ViewStore<ProfileScreen.ViewState, ProfileStore.Action>
    
    struct ViewState: Equatable {
        var status: ProfileStore.State.Status
        let loadingState: LoadingState
        var name: String
        var infoModels: [ProfileStore.State.PersonalInfoModel]
        var lifetimeId: String
        
        var isAuthorized: Bool {
            status == .authorized
        }
        
        init(state: ProfileStore.State) {
            self.status = state.status
            self.loadingState = state.loadingState
            self.name = state.name
            self.infoModels = state.infoModels
            self.lifetimeId = state.lifetimeId
        }
    }
    
    
    let store: StoreOf<ProfileStore>
    
    // MARK: - Body
    
    var body: some View {
        WithViewStore(
            store,
            observe: ViewState.init
        ) { viewStore in
            NavigationView {
                ZStack {
                    if viewStore.loadingState.isLoading {
                        Loader()
                    } else {
                        makeContent(with: viewStore)
                    }
                }.task {
                    viewStore.send(.onAppear)
                }
                .defaultPadding()
                .navigationTitle("Profile")
            }
        }
    }
    
    // MARK: - Content
    
    private func makeContent(with viewStore: Store) -> some View {
        ScrollView {
            VStack {
                if viewStore.isAuthorized {
                    makeAuthorizedView(with: viewStore)
                        .alert(
                            store.scope(state: \.alert),
                            dismiss: .alertDismissed
                        )
                        .confirmationDialog(
                            store.scope(state: \.confirmationDialog),
                            dismiss: .confirmationDialogDismissed
                        )
                } else {
                    unauthorizedView
                }
            }
        }
    }
    
    // MARK: - Authorized view
    
    private func makeAuthorizedView(with viewStore: Store) -> some View {
        VStack(alignment: .leading) {
            makeNameView(with: viewStore)
                .padding(.bottom, 30)
            
            makePersonalInfoBlock(with: viewStore)
                .padding(.bottom, 100)
            
            makeIdView(with: viewStore)
                .padding(.bottom, 100)
            
            makeDeleteButton(with: viewStore)
        }
        .padding(.vertical)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Name
    
    private func makeNameView(with viewStore: Store) -> some View {
        VStack(alignment: .leading) {
            Text("Name")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Text(viewStore.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button {
                    viewStore.send(.logout)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.2)
                            .stroke(Color.black)
                            .frame(width: 110, height: 40)
                        Text("Logout")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    // MARK: - Personal info block
    
    private func makePersonalInfoBlock(with viewStore: Store) -> some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(viewStore.infoModels, id: \.self) {
                makePersonalInfoView($0)
            }
        }
    }
    
    // MARK: - Personal info view
    
    private func makePersonalInfoView(_ model: ProfileStore.State.PersonalInfoModel) -> some View {
        HStack(alignment: .top, spacing: 20) {
            Image(model.iconName)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(model.title)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                if let subtitle = model.subtitle {
                    Text(subtitle)
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    // MARK: - ID view
    
    private func makeIdView(with viewStore: Store) -> some View {
        HStack {
            Text("ID")
            
            Spacer()
            
            Text(viewStore.lifetimeId)
                .padding(.trailing, 10)
        }
        .font(.body)
        .foregroundColor(.secondary)
        .padding(.horizontal, 30)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .frame(height: 64)
                .shadow(
                    color: .secondary,
                    radius: 12,
                    x: 2,
                    y: 2
                )
        }
    }
    
    // MARK: - Delete button
    
    private func makeDeleteButton(with viewStore: Store) -> some View {
        StandardButton(text: "Delete account") {
            viewStore.send(.confirmationDialogButtonTapped)
        }
    }
    
    // MARK: - Unauthorized view
    
    private var unauthorizedView: some View {
        VStack {
            Image("imgProfile")
                .frame(width: 186, height: 204)
                .padding(.bottom, 48)
            
            Text("This tab will display your profile information. To do this, you need to register")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
    }
    
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(store: .init(
            initialState: ProfileStore.State.initialState,
            reducer: ProfileStore()
        ))
    }
}

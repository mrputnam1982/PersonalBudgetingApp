//
//  LoginAndRegistrationView.swift
//  PersonalBudgetingApp
//
//  Created by Mike Putnam on 10/23/26.
//

import SwiftUI
enum menuStatus: CaseIterable, Identifiable, Hashable {
    case login, registration
    var id: Self {self}
    var title: String {
        switch self {
        case .login: return "Login"
        case .registration: return "Register"
        }
    }
}
struct LoginAndRegistrationView: View {
    @State private var currentMenuStatus: menuStatus = .login
//    @State private var auth = AuthViewModel()
    @Environment(AuthViewModel.self) private var auth
    var body: some View {
        NavigationStack{
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()

                ScrollView{
                    VStack(spacing: 20) {
                        switch(currentMenuStatus){
                        case .login: LoginView()
                        case .registration: RegistrationView()
                        }
                    }.padding()
                }.safeAreaInset(edge: .bottom) {
                    Picker("Selected action",
                           selection: $currentMenuStatus) {
                        ForEach(menuStatus.allCases){ status in
                            Text(status.title).bold().tag(status)
                        }
                    }.pickerStyle(.segmented).padding(40)
                }
            }
        }
    }
    


}

struct LoginView: View {
    @Environment(AuthViewModel.self) private var auth
    
    var body: some View{
        @Bindable var auth = auth
        Text("Login via email")
    
        TextField("Email", text: $auth.email).keyboardType(.emailAddress).textInputAutocapitalization(.never)
            .textContentType(.emailAddress).textFieldStyle(.roundedBorder)
        SecureField("Password", text: $auth.password).textFieldStyle(.roundedBorder)
        Button("Login") {
            Task{
                await auth.login()
            }
        }.disabled(!auth.canLogin || auth.isLoading)
            .buttonStyle(PrimaryButtonStyle())
            
    }
}

struct RegistrationView: View {
    @Environment(AuthViewModel.self) private var auth
    
    var body: some View{
        @Bindable var auth = auth
        Text("Register as a new user")
        TextField("Name", text: $auth.name).textFieldStyle(.roundedBorder)
        TextField("Email", text: $auth.email).keyboardType(.emailAddress).textInputAutocapitalization(.never)
                    .textContentType(.emailAddress).textFieldStyle(.roundedBorder)
        if(!auth.isEmailValid && !auth.email.isEmpty) {
            Text("Email Format Invalid")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        SecureField("Password", text: $auth.password).textFieldStyle(.roundedBorder)
        if !auth.password.isEmpty {
            PasswordRulesView(password: auth.password)
        }
        SecureField("Confirm Password", text: $auth.confirmPassword).textFieldStyle(.roundedBorder)
        if !auth.confirmPassword.isEmpty && !auth.passwordsMatch {
                    Text("Passwords don't match")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
        }
        
        Button("Register") {
            Task{
                await auth.register()
            }
        }.disabled(!auth.canRegister || auth.isLoading)
            .buttonStyle(PrimaryButtonStyle())
        if let info = auth.infoMessage {
            Label(info, systemImage: "envelope.badge")
                .font(.footnote)
                .foregroundStyle(.black)
        }

        if let error = auth.errorMessage {
            Text(error)
                .font(.footnote)
                .foregroundStyle(.black)
        }

    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(isEnabled ? .white : .white.opacity(0.6))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(
                isEnabled ? Color.black : Color.black.opacity(0.4),
                in: .rect(cornerRadius: 12)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)       // press feedback
            .animation(.easeOut(duration: 0.15), value: isEnabled)
    }
}

#Preview {
    LoginAndRegistrationView().environment(AuthViewModel())
}

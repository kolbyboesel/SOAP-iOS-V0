//
//  LogInView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 02/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var settings: UserSettings
    var logoFetcher: LogoFetcher
    @State  private var emailAddress: String = ""
    @State  private var password: String = ""
    @State private var showPassword = false
    @State private var isLoginInProgress = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var shouldNavigateToHome = false
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        
        GeometryReader { geometry in
            VStack (alignment: .center){
                
                Text("Log Into Your Account")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 50)
                    .padding()
                
                TextField("Email", text: self.$emailAddress)
                    .frame(width: geometry.size.width, height: 50)
                    .textContentType(.emailAddress)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    .accentColor(.red)
                    .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                    .cornerRadius(5)
                
                if showPassword {
                    ZStack{
                        TextField("Password", text: self.$password)
                            .frame(width: geometry.size.width, height: 50)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                            .foregroundColor(.gray)
                            .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                            .textContentType(.password)
                            .cornerRadius(5)
                        
                        Button(action: { self.showPassword.toggle() }) {
                            Image(systemName: "eye.circle")
                                .resizable()
                                .foregroundColor(.gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                        }
                        .padding()
                        .frame(width: geometry.size.width, alignment: .trailing)
                    }
                } else {
                    ZStack{
                        SecureField("Password", text: self.$password)
                            .frame(width: geometry.size.width, height: 50)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                            .foregroundColor(.gray)
                            .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
                            .textContentType(.password)
                            .cornerRadius(5)
                        
                        Button(action: { self.showPassword.toggle() }) {
                            Image(systemName: "eye.slash.circle")
                                .resizable()
                                .foregroundColor(.gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                        }
                        .padding()
                        .frame(width: geometry.size.width, alignment: .trailing)
                        
                        
                    }
                }
                
                Button(action: {
                    handleLoginSubmit()
                }) {
                    Text(isLoginInProgress ? "Logging In..." : "Log In")
                        .padding()
                        .frame(width: geometry.size.width, height: 40)
                        .foregroundColor(.white)
                        .background(isLoginInProgress ? Color.gray : Color.blue)
                        .cornerRadius(5)
                        .disabled(isLoginInProgress)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    
    func handleLoginSubmit() {
        isLoginInProgress = true
        let credentials = LoginCredentials(username: emailAddress, password: password)
        
        loginUser(withCredentials: credentials) { result in
            isLoginInProgress = false
            switch result {
            case .success(let user):
                settings.loggedIn = true
                DispatchQueue.main.async {
                    alertMessage = "Login successful!"
                    showAlert = true
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

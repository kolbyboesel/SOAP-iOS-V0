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
    @ObservedObject var logoFetcher: LogoFetcher
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    @State private var showPassword = false
    
    @State private var isLoginInProgress = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                    .accentColor(.SportScoresRed)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .foregroundColor(Color.primary)
                
                if showPassword {
                    ZStack{
                        TextField("Password", text: self.$password)
                            .frame(width: geometry.size.width, height: 50)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                            .background(Color(.systemGray6))
                            .textContentType(.password)
                            .cornerRadius(5)
                            .accentColor(.SportScoresRed)
                            .foregroundColor(Color.primary)
                        
                        
                        Button(action: { self.showPassword.toggle() }) {
                            Image(systemName: "eye.circle")
                                .resizable()
                                .foregroundColor(Color.primary)
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
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .accentColor(.SportScoresRed)
                            .foregroundColor(Color.primary)
                        
                        Button(action: { self.showPassword.toggle() }) {
                            Image(systemName: "eye.slash.circle")
                                .resizable()
                                .foregroundColor(Color.primary)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                        }
                        .padding()
                        .frame(width: geometry.size.width, alignment: .trailing)
                    }
                }
                
                Button(action: {
                    handleLoginSubmit(email: emailAddress, password: password)
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
    
    func handleLoginSubmit(email: String, password: String) {
        isLoginInProgress = true
        let credentials = LoginCredentials(username: email, password: password)
        
        loginUser(withCredentials: credentials, userSettings: settings) { result in
            isLoginInProgress = false
            switch result {
            case .success(_):
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

//
//  ChangePasswordView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var logoFetcher: LogoFetcher

    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    @State private var showPassword = false
    
    @State private var isActionInProgress = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                
                Text("Update Your Password")
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
                    handleChangePasswordSubmit(email: emailAddress, password: password)
                }) {
                    Text(isActionInProgress ? "Logging In..." : "Log In")
                        .padding()
                        .frame(width: geometry.size.width, height: 40)
                        .foregroundColor(.white)
                        .background(isActionInProgress ? Color.gray : Color.blue)
                        .cornerRadius(5)
                        .disabled(isActionInProgress)
                }
            }
            .accentColor(.white)

            .alert(isPresented: $showAlert) {
                Alert(title: Text("Change Password"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
    
    func handleChangePasswordSubmit(email: String, password: String) {
        isActionInProgress = true
        let credentials = LoginCredentials(username: email, password: password)
        
        loginUser(withCredentials: credentials, userSettings: settings) { result in
            isActionInProgress = false
            switch result {
            case .success(_):
                self.presentationMode.wrappedValue.dismiss()
                settings.loggedIn = true
                alertMessage = "Login successful!"
                showAlert = true
                
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

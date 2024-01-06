//
//  LogInView.swift
//  SwiftUIStarterKitApp
//
//  Created by Osama Naeem on 02/08/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import SwiftUI

var SignupEmail = ""
var SignupPsw = ""
var SignupFN = ""
var SignupLN = ""

struct SignupView: View {
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var logoFetcher: LogoFetcher
    
    @State private var emailAddress: String = ""
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    @State private var showPassword = false
    
    @State private var isSignupInProgress = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var showPayPalWebView = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack (alignment: .center){
                
                Text("Create an Account")
                    .font(.title)
                    .font(.system(size: 14, weight: .bold, design: Font.Design.default))
                    .padding(.bottom, 50)
                    .padding()
                
                TextField("First Name", text: self.$firstName)
                    .frame(width: geometry.size.width, height: 50)
                    .textContentType(.emailAddress)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    .accentColor(.SportScoresRed)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .foregroundColor(Color.primary)
                
                TextField("Last Name", text: self.$lastName)
                    .frame(width: geometry.size.width, height: 50)
                    .textContentType(.emailAddress)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    .accentColor(.SportScoresRed)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .foregroundColor(Color.primary)
                
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
                SecureField("Confirm Password", text: self.$passwordConfirm)
                    .frame(width: geometry.size.width, height: 50)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .accentColor(.SportScoresRed)
                    .foregroundColor(Color.primary)
                
                Button(action: {
                    handleSignupSubmit()
                }) {
                    Text(isSignupInProgress ? "Signing Up..." : "Sign Up")
                        .padding()
                        .frame(width: geometry.size.width, height: 40)
                        .foregroundColor(.white)
                        .background(isSignupInProgress ? Color.gray : Color.blue)
                        .cornerRadius(5)
                        .disabled(isSignupInProgress)
                }
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Signup"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .fullScreenCover(isPresented: $showPayPalWebView) {
            PayPalWebViewControllerRepresentable(userSettings: settings) {
                self.presentationMode.wrappedValue.dismiss()
                alertMessage = "Successfully Created Account and Logged In!"
                showAlert = true
            }
        }
    }
    func handleSignupSubmit() {
        guard !emailAddress.isEmpty, !firstName.isEmpty, !lastName.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }
        
        guard password == passwordConfirm else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        guard emailAddress.contains("@") else {
            alertMessage = "Invalid email address."
            showAlert = true
            return
        }
        
        isSignupInProgress = true
        
        SignupEmail = emailAddress
        SignupPsw = password
        SignupFN = firstName
        SignupLN = lastName
        
        initiatePayPalCheckout() {
            self.isSignupInProgress = false
            self.showPayPalWebView = true
        }
    }
}

func initiatePayPalCheckout(presentPayPalCheckout: @escaping () -> Void) {
    presentPayPalCheckout()
}

struct PayPalWebViewControllerRepresentable: UIViewControllerRepresentable {
    var userSettings: UserSettings
    var onCompletion: (() -> Void)?
    
    func makeUIViewController(context: Context) -> PayPalWebViewController {
        let viewController = PayPalWebViewController(userSettings: userSettings)
        viewController.onCompletion = onCompletion
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: PayPalWebViewController, context: Context) {
    }
}

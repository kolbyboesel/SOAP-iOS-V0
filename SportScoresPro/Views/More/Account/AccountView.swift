//
//  AccountView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @ObservedObject var logoFetcher: LogoFetcher
    @EnvironmentObject var userSettings: UserSettings
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(userSettings.firstName) \(userSettings.lastName)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(userSettings.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
                
                //VStack(spacing: 16) {
                  //  NavigationLink(destination: //ChangePasswordView(logoFetcher: logoFetcher)) {
                        //Text("Change Password")
                          //  .foregroundColor(.white)
                            //.frame(maxWidth: .infinity)
                          //  .padding()
                          //  .background(Color.blue)
                          //  .cornerRadius(10)
                   // }
                //}
                //.padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    userSettings.loggedIn = false
                    userSettings.lastName = ""
                    userSettings.firstName = ""
                    userSettings.email = ""
                    userSettings.profileMenuSelection = ""
                    self.presentationMode.wrappedValue.dismiss()

                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("Log Out")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()

                    }
                    .padding()
                }
                .background(Color(Color.SportScoresRed))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.large)
    }
}

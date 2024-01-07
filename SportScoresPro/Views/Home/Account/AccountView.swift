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
            }
            .navigationBarHidden(true)
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.large)
    }
}

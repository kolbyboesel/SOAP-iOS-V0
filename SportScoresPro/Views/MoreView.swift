//
//  AccountView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/23/23.
//

import SwiftUI

struct MoreView: View {
    @ObservedObject var logoFetcher: LogoFetcher
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                List {
                    if !userSettings.loggedIn {
                        Section {
                            NavigationLink(destination: SignupView(logoFetcher: logoFetcher)) {
                                Text("Sign Up")
                            }
                            NavigationLink(destination: LogInView(logoFetcher: logoFetcher).environmentObject(userSettings)) {
                                Text("Log In")
                            }
                        }
                    } else {
                        Section {
                            NavigationLink(destination: SignupView(logoFetcher: logoFetcher)) {
                                Text("Update Email")
                            }
                            NavigationLink(destination: SignupView(logoFetcher: logoFetcher)) {
                                Text("Update Password")
                            }
                        }
                    }
                    Section {
                        NavigationLink(destination: AboutView().accentColor(.white)) {
                            Text("About Me")
                        }
                    }
                    
                    if userSettings.loggedIn {
                        Section {
                            Button(action: {
                                userSettings.loggedIn = false
                            }) {
                                Text("Log Out")
                            }
                        }
                    }
                }
                .contentMargins(.top, 20)
                .navigationTitle("More")
            }
        }
        .accentColor(.white)
    }
}

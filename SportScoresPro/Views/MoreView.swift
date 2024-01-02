//
//  AccountView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/23/23.
//

import SwiftUI

struct MoreView: View {
    var logoFetcher: LogoFetcher
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                List {
                    if !settings.loggedIn {
                        Section {
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                            }
                            
                            if settings.loggedIn {
                                TabBar(logoFetcher: logoFetcher)
                            } else {
                                NavigationLink(destination: LogInView(logoFetcher: logoFetcher)) {
                                    Text("Log In")
                                }
                            }
                        }
                    } else {
                        Section {
                            NavigationLink(destination: SignUpView()) {
                                Text("Update Email")
                            }
                            
                            NavigationLink(destination: SignUpView()) {
                                Text("Update Password")
                            }
                        }
                        
                        
                    }
                    Section {
                        NavigationLink(destination: AboutView().accentColor(.white)) {
                            Text("About Me")
                        }
                    }
                    
                    
                    if settings.loggedIn {
                        Section {
                            Button(action: {
                                settings.loggedIn = false
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

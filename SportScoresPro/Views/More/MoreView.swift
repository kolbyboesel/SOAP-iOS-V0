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
                    if userSettings.loggedIn {
                        Section {
                            NavigationLink(destination: AccountView(logoFetcher: logoFetcher).environmentObject(userSettings)) {
                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .padding(.top, 5)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                        .foregroundColor(Color.primary)

                                    Text("Account")
                                        .foregroundColor(Color.primary)

                                }
                                
                            }
                        }
                    } else {
                        Section {
                            NavigationLink(destination: SignupView(logoFetcher: logoFetcher).environmentObject(userSettings)) {
                                HStack {
                                    Image(systemName: "person.crop.circle.fill.badge.plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .padding(.top, 5)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                        .foregroundColor(Color.primary)

                                    Text("Sign Up")
                                        .foregroundColor(Color.primary)

                                }
                            }
                            NavigationLink(destination: LogInView(logoFetcher: logoFetcher).environmentObject(userSettings)) {
                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .padding(.top, 5)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                        .foregroundColor(Color.primary)

                                    Text("Log In")
                                        .foregroundColor(Color.primary)

                                }
                            }
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: AboutView().accentColor(.white)) {
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(.top, 5)
                                .padding(.trailing, 15)
                                .padding(.bottom, 5)
                                .foregroundColor(Color.primary)

                            Text("About")
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

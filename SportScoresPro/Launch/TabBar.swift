//
//  TabBar.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/23/23.
//

import SwiftUI

extension Color {
    static let SportScoresRed = Color(red: 0.95686274509, green: 0.26274509803, blue: 0.21176470588)
}

struct TabBar: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedTab = 0    
    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case 0:
                NavigationView {
                    HomeView(logoFetcher: logoFetcher)
                        .environmentObject(userSettings)
                }
            case 1:
                NavigationView {
                    LiveScoresView(logoFetcher: logoFetcher)
                        .environmentObject(userSettings)
                }
            case 2:
                NavigationView {
                    SportsView(logoFetcher: logoFetcher)
                        .environmentObject(userSettings)
                }
            case 3:
                NavigationView {
                    MoreView(logoFetcher: logoFetcher)
                        .environmentObject(userSettings)
                }
            default:
                NavigationView {
                    HomeView(logoFetcher: logoFetcher)
                        .environmentObject(userSettings)
                    
                }
            }
            
            HStack(spacing: 0) {
                Spacer()
                
                Button(action: { self.selectedTab = 0 }) {
                    VStack{
                        if selectedTab == 0 {
                            Color.SportScoresRed.frame(height: 2)
                                .padding(.top, 0)

                        } else {
                            Color.clear.frame(height: 0)
                        }
                        VStack {
                            Image(systemName: "house")
                                .resizable()
                                .foregroundColor(selectedTab == 0 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .frame(maxWidth: 20)
                            
                            Text("Home")
                                .font(.system(size: 10))
                                .foregroundColor(selectedTab == 0 ? .SportScoresRed : .gray)
                        }
                    }
                }
                Spacer()
                Button(action: { self.selectedTab = 1 }) {
                    VStack {
                        if selectedTab == 1 {
                            Color.SportScoresRed.frame(height: 2)
                                .padding(.top, 0)

                        } else {
                            Color.clear.frame(height: 0)
                        }
                        VStack {
                            Image(systemName: "sportscourt")
                                .resizable()
                                .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .frame(maxWidth: 20)
                            
                            Text("Scores")
                                .font(.system(size: 10))
                                .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                        }
                    }
                }
                
                Spacer()
                Button(action: { self.selectedTab = 2 }) {
                    VStack {
                        if selectedTab == 2 {
                            Color.SportScoresRed.frame(height: 2)
                                .padding(.top, 0)

                        } else {
                            Color.clear.frame(height: 0)
                        }
                        VStack {
                            Image(systemName: "basketball")
                                .resizable()
                                .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .frame(maxWidth: 20)
                            
                            Text("Sports")
                                .font(.system(size: 10))
                                .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                        }
                    }
                }
                Spacer()
                Button(action: { self.selectedTab = 3 }) {
                    VStack {
                        if selectedTab == 3 {
                            Color.SportScoresRed.frame(height: 2)
                                .padding(.top, 0)
                        } else {
                            Color.clear.frame(height: 0)
                        }
                        VStack {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .frame(maxWidth: 20)
                            
                            Text("More")
                                .font(.system(size: 10))
                                .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.top, 0)
        .contentMargins(.bottom, 0)
        .contentMargins(.top, 0)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color.white)
    }
}

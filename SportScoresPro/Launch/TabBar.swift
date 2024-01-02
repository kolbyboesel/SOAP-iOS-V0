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
    var logoFetcher : LogoFetcher
    @State private var selectedTab = 0
    
    var body: some View {
        
        VStack {
            switch selectedTab {
            case 0:
                NavigationView {
                    HomeView()
                    
                }
            case 1:
                NavigationView {
                    SportsView(logoFetcher: logoFetcher)
                    
                }
            case 2:
                NavigationView {
                    MoreView(logoFetcher: logoFetcher)
                    
                }
            default:
                NavigationView {
                    HomeView()
                    
                }
            }
            
            HStack {
                Spacer()
                
                Button(action: { self.selectedTab = 0 }) {
                    VStack {
                        if selectedTab == 0 {
                            Color.SportScoresRed.frame(height: 2)
                        } else {
                            Color.clear.frame(height: 2)
                        }
                        VStack {
                            Image(systemName: "house")
                                .resizable()
                                .foregroundColor(selectedTab == 0 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                                .frame(maxWidth: 30)
                            
                            
                            Text("Home")
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 0 ? .SportScoresRed : .gray)
                        }
                    }
                    .frame(maxWidth: 50)
                }
                Spacer()
                Button(action: { self.selectedTab = 1 }) {
                    VStack {
                        if selectedTab == 1 {
                            Color.SportScoresRed.frame(height: 2)
                        } else {
                            Color.clear.frame(height: 2)
                        }
                        VStack {
                            Image(systemName: "sportscourt")
                                .resizable()
                                .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                                .frame(maxWidth: 30)
                            
                            Text("Sports")
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                        }
                    }
                    .frame(maxWidth: 50)


                }
                Spacer()
                Button(action: { self.selectedTab = 2 }) {
                    VStack {
                        if selectedTab == 2 {
                            Color.SportScoresRed.frame(height: 2)
                        } else {
                            Color.clear.frame(height: 0)
                        }
                        VStack {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                                .frame(maxWidth: 30)
                            
                            Text("More")
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                        }
                    }
                    .frame(maxWidth: 50)


                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
    }
}




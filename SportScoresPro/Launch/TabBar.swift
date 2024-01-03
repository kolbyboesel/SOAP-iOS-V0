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
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @State private var selectedTab = 0
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appEnvironment: AppEnvironment
    
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                NavigationView {
                    HomeView(logoFetcher: logoFetcher, selectedTab: $selectedTab)
                        .environmentObject(userSettings)
                        .environmentObject(appEnvironment)
                }
                
            case 1:
                NavigationView {
                    SportsView(logoFetcher: logoFetcher, selectedTab: $selectedTab)
                        .environmentObject(userSettings)
                        .environmentObject(sharedSportViewModel)
                        .environmentObject(appEnvironment)
                }
            case 2:
                NavigationView {
                    MoreView(logoFetcher: logoFetcher)
                        .environmentObject(userSettings)
                }
            default:
                NavigationView {
                    HomeView(logoFetcher: logoFetcher, selectedTab: $selectedTab)
                        .environmentObject(userSettings)
                    
                }
            }
            VStack{
                Spacer()
                
                HStack {
                    if (appEnvironment.sportBarActive == false) {
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
                        }
                        Spacer()
                    }
                }
                .padding(.top, 0)
                .contentMargins(.bottom, 0)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(Color.white)
            }
        }
    }
}

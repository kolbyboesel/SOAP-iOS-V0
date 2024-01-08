//
//  FavoritesTabBar.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct FavoritesTeamTabBar: View {
    @ObservedObject var logoFetcher : LogoFetcher
    var teamInfo : SearchData
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var selectedTab = 0
    
    
    var body: some View {
        ZStack(){
            VStack(spacing: 0){
                HStack(spacing: 0) {
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            VStack {
                                Text("Scores")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 0 ? .bold : .regular)
                                
                            }
                            if selectedTab == 0 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 0)
                .padding(.top)
                .padding(.leading)
                .padding(.trailing)
                .background(Color.SportScoresRed)
                
                Group {
                    switch selectedTab {
                    case 0:
                        NavigationView {
                            TeamScoresView(team: teamInfo, ScoreKey: teamInfo.tournament?.uniqueTournament?.name ?? "", sportID: teamInfo.sport.id, logoFetcher: logoFetcher)
                                .navigationBarHidden(true)
                        }
                        
                    default:
                        NavigationView {
                            TeamScoresView(team: teamInfo, ScoreKey: teamInfo.tournament?.uniqueTournament?.name ?? "", sportID: teamInfo.sport.id, logoFetcher: logoFetcher)
                                .navigationBarHidden(true)
                        }
                    }
                }
                .zIndex(0)
            }
            .cornerRadius(12)
            .background(Color(.systemGray6))
        }
    }
}

struct FavoritesLeagueTabBar: View {
    var sportName: String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName : String
    var sportID : Int
    
    @ObservedObject var logoFetcher : LogoFetcher
    @Binding var showDropdownBtn : Bool

    @EnvironmentObject var userSettings: UserSettings
    
    @State private var selectedTab = 0
    @State private var showOddsDropdown = false
    
    @Binding var market : String
    @State var isMenuVisible = false
    
    var body: some View {
        ZStack(){
            VStack(spacing: 0){
                HStack(spacing: 0) {
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 0
                        showDropdownBtn = false
                    }) {
                        VStack {
                            VStack {
                                Text("Scores")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 0 ? .bold : .regular)
                                
                            }
                            if selectedTab == 0 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 1
                        showDropdownBtn = true
                    }) {
                        VStack {
                            VStack {
                                Text("Odds")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 1 ? .bold : .regular)
                                
                            }
                            if selectedTab == 1 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 2
                        showDropdownBtn = false
                    }) {
                        VStack {
                            VStack {
                                Text("Predictions")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 2 ? .bold : .regular)
                                
                            }
                            if selectedTab == 2 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 0)
                .padding(.top)
                .padding(.leading)
                .padding(.trailing)
                .background(Color.SportScoresRed)
                
                Group {
                    switch selectedTab {
                    case 0:
                        NavigationView {
                            FavoriteScoresView(ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                                .navigationBarHidden(true)
                        }
                        
                    case 1:
                        NavigationView {
                            FavoriteOddsView(OddKey: OddKey, sportID: sportID, market: $market, logoFetcher: logoFetcher)
                                .navigationBarHidden(true)
                        }
                        
                    case 2:
                        NavigationView {
                            FavoritePredictionView(PredictionKey: PredictionKey, sportID: sportID, seasonName: seasonName, market: $market, logoFetcher: logoFetcher)
                                .environmentObject(userSettings)
                                .navigationBarHidden(true)
                        }
                        
                    default:
                        NavigationView {
                            FavoriteScoresView(ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                                .navigationBarHidden(true)
                        }
                    }
                }
                .zIndex(0)
            }
            .cornerRadius(12)
            .background(Color(.systemGray6))
        }
    }
}

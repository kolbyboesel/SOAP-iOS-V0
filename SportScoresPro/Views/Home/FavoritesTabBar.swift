//
//  FavoritesTabBar.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct FavoritesTeamToggleButton: View {
    @ObservedObject var logoFetcher : LogoFetcher
    var teamInfo : SearchData
    @Binding var showDropdownBtn : Bool

    @EnvironmentObject var userSettings: UserSettings
    
    @State private var selectedTab = 0
    @State var imageName = "sportscourt.fill"
    
    var body: some View {
        ZStack {
            
            Group {
                switch selectedTab {
                case 0:
                    TeamScoresView(team: teamInfo, ScoreKey: teamInfo.tournament?.uniqueTournament?.name ?? "", sportID: teamInfo.sport.id, logoFetcher: logoFetcher)
                        .navigationBarHidden(true)
                default:
                    TeamScoresView(team: teamInfo, ScoreKey: teamInfo.tournament?.uniqueTournament?.name ?? "", sportID: teamInfo.sport.id, logoFetcher: logoFetcher)
                        .navigationBarHidden(true)
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.SportScoresRed)
                        .clipShape(Circle())
                        .contextMenu {
                            Button(action: {
                                selectedTab = 0
                                imageName = "sportscourt.fill"
                                showDropdownBtn = false
                            }) {
                                Text("Scores")
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
            .zIndex(1)
        }
    }
}

struct FavoritesLeagueToggleButton: View {
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
    @State var imageName = "sportscourt.fill"
    
    var body: some View {
        ZStack {
            
            Group {
                switch selectedTab {
                case 0:
                    SportScoresView(ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                case 1:
                    SportOddsView(OddKey: OddKey, sportID: sportID, market: $market, logoFetcher: logoFetcher)
                case 2:
                    SportPredictionView(PredictionKey: PredictionKey, sportID: sportID, seasonName: seasonName, market: $market, logoFetcher: logoFetcher)
                        .environmentObject(userSettings)
                default:
                    SportScoresView(ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.SportScoresRed)
                        .clipShape(Circle())
                        .contextMenu {
                            Button(action: {
                                selectedTab = 0
                                imageName = "sportscourt.fill"
                                showDropdownBtn = false
                            }) {
                                Text("Scores")
                            }
                            Button(action: {
                                selectedTab = 1
                                imageName = "dollarsign"
                                showDropdownBtn = true
                            }) {
                                Text("Odds")
                            }
                            Button(action: {
                                selectedTab = 2
                                imageName = "clock.badge"
                                showDropdownBtn = false
                            }) {
                                Text("Predictions")
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
            .zIndex(1)
        }
    }
}

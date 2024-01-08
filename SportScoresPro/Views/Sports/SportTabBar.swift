//
//  SportTabBar.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct SportTabBar: View {
    var sportName: String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName : String
    var sportID : Int
    
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var selectedTab = 0
    @State private var showOddsDropdown = false
    @State private var showFilterDropdown = false

    @State var market = "Moneyline"
    @State var isMenuVisible = false
    
    var body: some View {
        ZStack(){
            VStack(spacing: 0){
                HStack(spacing: 0) {
                    
                    Spacer()
                    
                    Button(action: { selectedTab = 0 }) {
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
                            SportScoresView(ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                                .navigationBarHidden(true)
                        }
                        .navigationBarItems(trailing: CollegeFilterDropdown(sportName: sportName, market: $market, showFilterDropdown: $showFilterDropdown))
                        .navigationTitle("\(sportName) Scores")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 1:
                        NavigationView {
                            SportOddsView(OddKey: OddKey, sportID: sportID, market: $market, logoFetcher: logoFetcher)
                                .navigationBarHidden(true)
                        }
                        .navigationBarItems(trailing: OddsMenuButton(market: $market, isMenuVisible: $showOddsDropdown))
                        .navigationTitle("\(sportName) Odds")
                        .navigationBarTitleDisplayMode(.inline)
                        
                        
                    case 2:
                        NavigationView {
                            SportPredictionView(PredictionKey: PredictionKey, sportID: sportID, seasonName: seasonName, market: $market, logoFetcher: logoFetcher)
                                .environmentObject(userSettings)
                                .navigationBarHidden(true)
                        }
                        .navigationTitle("\(sportName) Predictions")
                        .navigationBarTitleDisplayMode(.inline)
                        
                        
                    default:
                        NavigationView {
                            SportScoresView(ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                                .navigationBarHidden(true)
                        }
                        .navigationTitle("\(sportName) Scores")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .zIndex(0)
            }
            
            if showOddsDropdown {
                VStack {
                    OddsDropdownMenu(market: $market, isMenuVisible: $showOddsDropdown)
                    Spacer()
                }
                .zIndex(1)
            }
        }
    }
}

struct CollegeFilterDropdown: View {
    var sportName: String
    @Binding var market : String
    @Binding var showFilterDropdown : Bool
    
    var body: some View {
        if sportName.contains("College"){
            OddsMenuButton(market: $market, isMenuVisible: $showFilterDropdown)
        }
    }
}

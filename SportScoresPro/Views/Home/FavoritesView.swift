//
//  FavoritesView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    
    @State private var showDropdownBtn = false
    @State private var showOddsDropdown = false
    @State var market = "Moneyline"
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        
                        ForEach(Array(settings.userFavorites.enumerated()), id: \.element.id) { index, item in
                            Button(action: { selectedTab = index }) {
                                VStack {
                                    Text(item.sportName)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .fontWeight(selectedTab == index ? .bold : .regular)
                                    
                                    if selectedTab == index {
                                        Color.white.frame(height: 3)
                                    } else {
                                        Color.clear.frame(height: 0)
                                    }
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                        }
                        
                        let offset = settings.userFavorites.count
                        
                        
                        ForEach(Array(settings.teamFavorites.enumerated()), id: \.element.id) { index, item in
                            Button(action: { selectedTab = (index + offset)}) {
                                VStack {
                                    Text(item.shortName)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .fontWeight(selectedTab == (index + offset) ? .bold : .regular)
                                    
                                    if selectedTab == (index + offset) {
                                        Color.white.frame(height: 3)
                                    } else {
                                        Color.clear.frame(height: 0)
                                    }
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing)
                        }
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                .padding(.top)
                .background(Color.SportScoresRed)
                
                Spacer()
                
                Group {
                    if selectedTab < settings.userFavorites.count {
                        let item = settings.userFavorites[selectedTab]
                        NavigationView {
                            FavoritesLeagueTabBar(sportName: item.sportName, ScoreKey: item.ScoreKey, OddKey: item.OddKey, PredictionKey: item.PredictionKey, seasonName: item.seasonName, sportID: item.sportID, logoFetcher: logoFetcher, showDropdownBtn: $showDropdownBtn, market: $market)
                                .environmentObject(settings)
                                .id(selectedTab)
                        }
                        .padding()
                        .navigationBarTitleDisplayMode(.inline)
                        
                    } else {
                        let adjustedIndex = selectedTab - settings.userFavorites.count
                        let item = settings.teamFavorites[adjustedIndex]
                        NavigationView {
                            FavoritesTeamTabBar(logoFetcher: logoFetcher, teamInfo: item)
                                .environmentObject(settings)
                                .id(selectedTab)
                        }
                        .padding()
                    }
                }
                
                
                if showOddsDropdown {
                    VStack {
                        Spacer()
                        OddsDropdownMenu(market: $market, isMenuVisible: $showOddsDropdown)
                            .transition(.move(edge: .top))
                    }
                    .zIndex(1)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        
    }
}

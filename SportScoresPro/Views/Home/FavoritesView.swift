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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(settings.userFavorites.enumerated()), id: \.element.id) { index, item in
                            UserFavoriteButton(item: item, index: index, selectedTab: $selectedTab)
                        }
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        
                        let offset = settings.userFavorites.count
                        
                        
                        ForEach(Array(settings.teamFavorites.enumerated()), id: \.element.id) { index, item in
                            UserTeamFavoriteButton(logoFetcher: logoFetcher, item: item, index: index, offset: offset, selectedTab: $selectedTab)
                        }
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                }
                .padding(.bottom, 10)
                .padding(.top, 10)
                .background(Color.SportScoresRed)
                
                VStack(spacing: 0) {
                    Group {
                        if selectedTab < settings.userFavorites.count {
                            let item = settings.userFavorites[selectedTab]
                            NavigationView {
                                FavoritesLeagueToggleButton(sportName: item.sportName, ScoreKey: item.ScoreKey, OddKey: item.OddKey, PredictionKey: item.PredictionKey, seasonName: item.seasonName, sportID: item.sportID, logoFetcher: logoFetcher, showDropdownBtn: $showDropdownBtn, market: $market)
                                    .environmentObject(settings)
                                    .id(selectedTab)
                            }
                            
                        } else {
                            let adjustedIndex = selectedTab - settings.userFavorites.count
                            let item = settings.teamFavorites[adjustedIndex]
                            NavigationView {
                                FavoritesTeamToggleButton(logoFetcher: logoFetcher, teamInfo: item, showDropdownBtn: $showDropdownBtn)
                                    .environmentObject(settings)
                                    .id(selectedTab)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct UserFavoriteButton: View {
    var item: SportMenuItemModel
    var index: Int
    @Binding var selectedTab: Int
    
    var body: some View {
        Button(action: { selectedTab = index }) {
            HStack {
                Image(item.sportName + "Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 15)
                    .padding(.trailing, 5)
                
                
                Text(item.seasonName)
                    .font(.system(size: 14))
                    .foregroundColor(selectedTab == index ? .SportScoresRed : .white)
                    .fontWeight(selectedTab == index ? .bold : .regular)
            }
            .padding(10)
            .background(Color(selectedTab == index ? .white : .white.opacity(0.4)))
            .cornerRadius(10)


        }
    }
}

struct UserTeamFavoriteButton: View {
    @ObservedObject var logoFetcher : LogoFetcher
    var item: SearchData
    var index: Int
    var offset : Int
    @Binding var selectedTab: Int

    var body: some View {
        Button(action: { selectedTab = (index + offset) }) {
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: item.id, teamName: item.name) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 15)
                        .padding(.trailing, 5)
                } else {
                    ProgressView()
                        .onAppear {
                            logoFetcher.fetchLogo(forTeam: item.id, teamName: item.name)
                        }
                        .frame(width: 15, height: 15)
                }
                
                Text(item.shortName)
                    .font(.system(size: 14))
                    .foregroundColor(selectedTab == (index + offset) ? .SportScoresRed : .white)
                    .fontWeight(selectedTab == (index + offset) ? .bold : .regular)
            }
            .padding(10)
            .background(Color(selectedTab == (index + offset) ? .white : .white.opacity(0.4)))
            .cornerRadius(10)
        }
    }
}



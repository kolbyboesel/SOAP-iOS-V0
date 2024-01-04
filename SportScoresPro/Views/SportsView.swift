//
//  SportsView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/2/24.
//

import Foundation
import SwiftUI

struct SportsView: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel

    @State private var isItemSelected = false
    
    let sportMenuArray: [SportMenuItemModel] = [
        SportMenuItemModel(id: 1, sportName: "NFL", ScoreKey: "NFL 23/24", OddKey: "americanfootball_nfl", PredictionKey: "football", seasonName: "NFL", sportID: 63),
        SportMenuItemModel(id: 2,sportName: "NBA",  ScoreKey: "NBA 23/24", OddKey: "basketball_nba", PredictionKey: "basketball", seasonName: "NBA", sportID: 2),
        SportMenuItemModel(id: 3,sportName: "MLB", ScoreKey: "MLB 24/25", OddKey: "baseball_mlb", PredictionKey: "baseball", seasonName: "MLB", sportID: 64),
        SportMenuItemModel(id: 4,sportName: "NHL", ScoreKey: "NHL 23/24", OddKey: "icehockey_nhl", PredictionKey: "icehockey", seasonName: "NHL",sportID: 4),
        SportMenuItemModel(id: 5,sportName: "College Football", ScoreKey: "NCAA Division I, FBS Post Season 23/24", OddKey: "americanfootball_ncaaf", PredictionKey: "football", seasonName: "NCAA Men",sportID: 63),
        SportMenuItemModel(id: 6,sportName: "College Basketball", ScoreKey: "NCAA, Regular Season 23/24", OddKey: "basketball_ncaab", PredictionKey: "basketball", seasonName: "NCAA Men",sportID: 2),
        SportMenuItemModel(id: 7,sportName: "College Baseball", ScoreKey: "NCAARegularSeason", OddKey: "baseball_ncaa", PredictionKey: "baseball", seasonName: "NCAA Men",sportID: 64),
        SportMenuItemModel(id: 8,sportName: "Premier League", ScoreKey: "Premier League 23/24", OddKey: "soccer_epl", PredictionKey: "football", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 9,sportName: "LaLiga Santander", ScoreKey: "LaLiga 23/24", OddKey: "soccer_spain_la_liga", PredictionKey: "football", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 10,sportName: "Ligue 1", ScoreKey: "Ligue 1 23/24", OddKey: "soccer_france_ligue_one", PredictionKey: "football", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 11,sportName: "Serie A", ScoreKey: "Serie A 23/24", OddKey: "soccer_italy_serie_a", PredictionKey: "football", seasonName: "NFL", sportID: 1),
        SportMenuItemModel(id: 12,sportName: "Bundesliga", ScoreKey: "Bundesliga 23/24", OddKey: "soccer_germany_bundesliga", PredictionKey: "football", seasonName: "NFL", sportID: 1),
        SportMenuItemModel(id: 13,sportName: "MLS", ScoreKey: "MLS 23/24", OddKey: "soccer_usa_mls", PredictionKey: "football", seasonName: "NFL", sportID: 1),]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(sportMenuArray, id: \.id) { item in
                    SportMenuItem(sportName: item.sportName, ScoreKey: item.ScoreKey, OddKey: item.OddKey, PredictionKey: item.PredictionKey, seasonName: item.seasonName, sportID: item.sportID, logoFetcher: logoFetcher)
                        .environmentObject(sharedSportViewModel)
                        .environmentObject(settings)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Sports")
            .contentMargins(.top, 20)
            .contentMargins(.bottom, 20)

        }
        .accentColor(.white)
    }
}

struct SportMenuItemModel {
    var id: Int
    var sportName : String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName: String
    var sportID : Int
}

struct SportMenuItem: View{
    var sportName: String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName: String
    var sportID : Int
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
        
    var body: some View {
        NavigationLink(destination: SportPlaceholderPage(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, seasonName: seasonName, sportID: sportID, logoFetcher: logoFetcher)
            .environmentObject(settings)
            .environmentObject(sharedSportViewModel)) {
            HStack {
                Image(sportName + "Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.top, 5)
                    .padding(.trailing, 5)
                    .padding(.bottom, 5)
                Text(sportName)
            }
        }
    }
}

struct SportPlaceholderPage: View{
    var sportName: String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName : String
    var sportID : Int
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedTab = 1
    
    var body: some View {
        SportTabBar(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, seasonName: seasonName, sportID: sportID, logoFetcher: logoFetcher)
            .environmentObject(settings)
            .environmentObject(sharedSportViewModel)
    }
}

struct SportTabBar: View {
    var sportName: String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName : String
    var sportID : Int
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var selectedTab = 0
    @State private var showOddsDropdown = false
    @State private var showPredictionsDropdown = false
    
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
                                    .font(.system(size: 15))
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
                                    .font(.system(size: 15))
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
                                    .font(.system(size: 15))
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
                            SportScoresView(sportName: sportName, ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                                .environmentObject(sharedSportViewModel)
                                .environmentObject(userSettings)
                                .navigationBarHidden(true)
                        }
                        .navigationTitle("\(sportName) Scores")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 1:
                        NavigationView {
                            SportOddsView(market: $market, sportName: sportName, OddKey: OddKey, sportID: sportID, logoFetcher: logoFetcher)
                                .environmentObject(sharedSportViewModel)
                                .environmentObject(userSettings)
                                .navigationBarHidden(true)
                        }
                        .navigationBarItems(trailing: OddsMenuButton(isMenuVisible: $showOddsDropdown, market: $market))
                        .navigationTitle("\(sportName) Odds")
                        .navigationBarTitleDisplayMode(.inline)
                        
                        
                    case 2:
                        NavigationView {
                            SportPredictionView(market: $market, sportName: sportName, PredictionKey: PredictionKey, sportID: sportID, seasonName: seasonName, logoFetcher: logoFetcher)
                                .environmentObject(sharedSportViewModel)
                                .environmentObject(userSettings)
                                .navigationBarHidden(true)
                        }
                        .navigationBarItems(trailing: PredictionMenuButton(isMenuVisible: $showPredictionsDropdown, market: $market))
                        .navigationTitle("\(sportName) Predictions")
                        .navigationBarTitleDisplayMode(.inline)
                        
                        
                    default:
                        NavigationView {
                            SportScoresView(sportName: sportName, ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                                .environmentObject(sharedSportViewModel)
                                .environmentObject(userSettings)
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
            
            if showPredictionsDropdown {
                VStack {
                    PredictionDropdownMenu(market: $market, isMenuVisible: $showPredictionsDropdown)
                    Spacer()
                }
                .zIndex(1)
            }
        }
    }
}

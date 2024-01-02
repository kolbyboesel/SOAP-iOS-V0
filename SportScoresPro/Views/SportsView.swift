//
//  SportsView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/2/24.
//

import Foundation
import SwiftUI

struct SportsView: View {
    var logoFetcher : LogoFetcher
    @Binding var selectedTab : Int
    @EnvironmentObject var settings: UserSettings
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
                    SportMenuItem(sportName: item.sportName, ScoreKey: item.ScoreKey, OddKey: item.OddKey, PredictionKey: item.PredictionKey, seasonName: item.seasonName, sportID: item.sportID, logoFetcher: logoFetcher, selectedTab: $selectedTab)
                        .environmentObject(settings)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Sports")
            .contentMargins(.top, 20)
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
    var logoFetcher : LogoFetcher
    @Binding var selectedTab : Int

    @EnvironmentObject var settings: UserSettings
    
    @State private var selectedView: SelectedView = .scores
    
    var body: some View {
        NavigationLink(destination: SportPlaceholderPage(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, seasonName: seasonName, sportID: sportID, logoFetcher: logoFetcher, selectedTabBarTab: $selectedTab).environmentObject(settings)) {
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
    var logoFetcher : LogoFetcher
    @Binding var selectedTabBarTab : Int
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                NavigationView {
                    SportScoresView(sportName: sportName, ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                        .navigationBarHidden(true)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(sportName + " Scores")
                
            case 1:
                NavigationView {
                    SportOddsView(sportName: sportName, OddKey: OddKey, sportID: sportID, logoFetcher: logoFetcher)
                        .navigationBarHidden(true)

                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(sportName + " Betting Odds")
                
            case 2:
                NavigationView {
                    SportPredictionView(sportName: sportName, PredictionKey: PredictionKey, sportID: sportID, seasonName: seasonName, logoFetcher: logoFetcher)
                        .environmentObject(settings)
                        .navigationBarHidden(true)

                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(sportName + " Predictions")
                
            case 3:
                NavigationView {
                    ContentView(logoFetcher: logoFetcher)
                        .environmentObject(settings)
                        .navigationBarHidden(true)

                }
                .onAppear{
                    settings.tabBarVisible = true
                    selectedTabBarTab = 0
                    presentationMode.wrappedValue.dismiss()
                }
                .navigationBarHidden(true)
                
            default:
                NavigationView {
                    SportScoresView(sportName: sportName, ScoreKey: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                        .navigationBarHidden(true)

                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(sportName + " Scores")
            }
            
            if settings.tabBarVisible != true {
                VStack{
                    
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: { self.selectedTab = 3 }) {
                            VStack {
                                if selectedTab == 3 {
                                    Color.SportScoresRed.frame(height: 2)
                                } else {
                                    Color.clear.frame(height: 2)
                                }
                                VStack {
                                    Image(systemName: "house")
                                        .resizable()
                                        .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 30)
                                        .frame(maxWidth: 30)
                                    
                                    
                                    Text("Home")
                                        .font(.system(size: 12))
                                        .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                                }
                            }
                        }
                        Spacer()
                        
                        Button(action: { self.selectedTab = 0 }) {
                            VStack {
                                if selectedTab == 0 {
                                    Color.SportScoresRed.frame(height: 2)
                                } else {
                                    Color.clear.frame(height: 2)
                                }
                                VStack {
                                    Image(systemName: "sportscourt")
                                        .resizable()
                                        .foregroundColor(selectedTab == 0 ? .SportScoresRed : .gray)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 30)
                                        .frame(maxWidth: 30)
                                    
                                    
                                    Text("Scores")
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
                                    Image(systemName: "dollarsign")
                                        .resizable()
                                        .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 30)
                                        .frame(maxWidth: 30)
                                    
                                    Text("Odds")
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
                                    Image(systemName: "hourglass")
                                        .resizable()
                                        .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 30)
                                        .frame(maxWidth: 30)
                                    
                                    Text("Predictions")
                                        .font(.system(size: 12))
                                        .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                                }
                            }
                            
                        }
                        Spacer()
                    }
                    .padding(.top, 0)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .background(Color.white)
                }
            }
        }
        .onAppear {
            settings.tabBarVisible = false
        }
        .onDisappear {
            settings.tabBarVisible = true
            presentationMode.wrappedValue.dismiss()
        }
    }
}

enum SelectedView {
    case scores, odds, predictions
}

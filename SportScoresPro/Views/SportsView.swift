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
    @Binding var selectedTab : Int
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @EnvironmentObject var appEnvironment: AppEnvironment

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
                        .environmentObject(sharedSportViewModel)
                        .environmentObject(settings)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.bottom, 60)
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
    @ObservedObject var logoFetcher : LogoFetcher
    @Binding var selectedTab : Int
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @EnvironmentObject var appEnvironment: AppEnvironment
        
    var body: some View {
        NavigationLink(destination: SportPlaceholderPage(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, seasonName: seasonName, sportID: sportID, logoFetcher: logoFetcher, selectedTabBarTab: $selectedTab)
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
    @Binding var selectedTabBarTab : Int
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @EnvironmentObject var appEnvironment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var selectedTab = 1
    
    var body: some View {
        SportTabBar(sportName: sportName, selectedTab: $selectedTab, selectedMainTab: $selectedTabBarTab, logoFetcher: logoFetcher)
            .environmentObject(settings)
            .environmentObject(sharedSportViewModel)
            .environmentObject(appEnvironment)
                
        .onAppear {
            appEnvironment.sportBarActive = true
            sharedSportViewModel.sportName = sportName
            sharedSportViewModel.scoreKey = ScoreKey
            sharedSportViewModel.oddKey = OddKey
            sharedSportViewModel.predictionKey = PredictionKey
            sharedSportViewModel.seasonName = seasonName
            sharedSportViewModel.sportID = sportID
        }
    }
}

struct SportTabBar: View {
    var sportName : String
    @Binding var selectedTab : Int
    @Binding var selectedMainTab : Int
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @EnvironmentObject var appEnvironment: AppEnvironment
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                    TabBar(logoFetcher: logoFetcher)
                        .environmentObject(userSettings)
                        .environmentObject(appEnvironment)
                        .environmentObject(sharedSportViewModel)
                        .onAppear(){
                            selectedMainTab = 0
                            self.presentationMode.wrappedValue.dismiss()
                        }
                
            case 1:
                NavigationView {
                    SportScoresView(sportName: sharedSportViewModel.sportName, ScoreKey: sharedSportViewModel.scoreKey, sportID: sharedSportViewModel.sportID, logoFetcher: logoFetcher)
                        .environmentObject(sharedSportViewModel)
                        .environmentObject(userSettings)
                        .navigationBarHidden(true)
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(sportName + " Scores")
            case 2:
                NavigationView {
                    SportOddsView(sportName: sharedSportViewModel.sportName, OddKey: sharedSportViewModel.oddKey, sportID: sharedSportViewModel.sportID, logoFetcher: logoFetcher)
                        .environmentObject(sharedSportViewModel)
                        .environmentObject(userSettings)
                        .navigationBarHidden(true)
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(sportName + " Betting Odds")
            case 3:
                NavigationView {
                    SportPredictionView(sportName: sharedSportViewModel.sportName, PredictionKey: sharedSportViewModel.predictionKey, sportID: sharedSportViewModel.sportID, seasonName: sharedSportViewModel.seasonName, logoFetcher: logoFetcher)
                        .environmentObject(sharedSportViewModel)
                        .environmentObject(userSettings)
                        .navigationBarHidden(true)
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(sportName + " Predictions")
            default:
                NavigationView {
                    SportScoresView(sportName: sharedSportViewModel.sportName, ScoreKey: sharedSportViewModel.scoreKey, sportID: sharedSportViewModel.sportID, logoFetcher: logoFetcher)
                        .environmentObject(sharedSportViewModel)
                        .environmentObject(userSettings)
                        .navigationBarHidden(true)
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(sportName + " Scores")
            }
            VStack{
                Spacer()
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: { selectedTab = 0 }) {
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
                    
                    Button(action: { selectedTab = 1 }) {
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
                                
                                
                                Text("Scores")
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTab == 1 ? .SportScoresRed : .gray)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: { selectedTab = 2 }) {
                        VStack {
                            if selectedTab == 2 {
                                Color.SportScoresRed.frame(height: 2)
                            } else {
                                Color.clear.frame(height: 2)
                            }
                            VStack {
                                Image(systemName: "dollarsign")
                                    .resizable()
                                    .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                                    .frame(maxWidth: 30)
                                
                                Text("Odds")
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTab == 2 ? .SportScoresRed : .gray)
                            }
                        }
                        
                        
                    }
                    
                    Spacer()
                    
                    Button(action: { selectedTab = 3 }) {
                        VStack {
                            if selectedTab == 3 {
                                Color.SportScoresRed.frame(height: 2)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                            VStack {
                                Image(systemName: "hourglass")
                                    .resizable()
                                    .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                                    .frame(maxWidth: 30)
                                
                                Text("Predictions")
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTab == 3 ? .SportScoresRed : .gray)
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
                }
            }
        }
    }
}

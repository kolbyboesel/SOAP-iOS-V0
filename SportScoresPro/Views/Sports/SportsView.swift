//
//  SportsView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/2/24.
//

import Foundation
import SwiftUI

struct SportMenuItemModel: Codable {
    var id: Int
    var sportName : String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName: String
    var sportID : Int
}

struct SportsView: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @EnvironmentObject var settings: UserSettings
    
    @State private var isItemSelected = false
    
    let sportMenuArray: [SportMenuItemModel] = [
        SportMenuItemModel(id: 1, sportName: "NFL", ScoreKey: "NFL", OddKey: "americanfootball_nfl", PredictionKey: "football", seasonName: "NFL", sportID: 63),
        SportMenuItemModel(id: 2,sportName: "NBA",  ScoreKey: "NBA", OddKey: "basketball_nba", PredictionKey: "basketball", seasonName: "NBA", sportID: 2),
        SportMenuItemModel(id: 3,sportName: "MLB", ScoreKey: "MLB", OddKey: "baseball_mlb", PredictionKey: "baseball", seasonName: "MLB", sportID: 64),
        SportMenuItemModel(id: 4,sportName: "NHL", ScoreKey: "NHL", OddKey: "icehockey_nhl", PredictionKey: "icehockey", seasonName: "NHL",sportID: 4),
        SportMenuItemModel(id: 5,sportName: "College Football", ScoreKey: "NCAA Division I, FBS Post Season", OddKey: "americanfootball_ncaaf", PredictionKey: "football", seasonName: "NCAA Men",sportID: 63),
        SportMenuItemModel(id: 6,sportName: "College Basketball", ScoreKey: "NCAA Men", OddKey: "basketball_ncaab", PredictionKey: "basketball", seasonName: "NCAA Men",sportID: 2),
        SportMenuItemModel(id: 7,sportName: "College Baseball", ScoreKey: "NCAA Men", OddKey: "baseball_ncaa", PredictionKey: "baseball", seasonName: "NCAA Men",sportID: 64),
        SportMenuItemModel(id: 8,sportName: "Premier League", ScoreKey: "Premier League", OddKey: "soccer_epl", PredictionKey: "Premier League", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 9,sportName: "LaLiga Santander", ScoreKey: "LaLiga", OddKey: "soccer_spain_la_liga", PredictionKey: "La Liga", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 10,sportName: "Ligue 1", ScoreKey: "Ligue 1", OddKey: "soccer_france_ligue_one", PredictionKey: "Ligue 1", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 11,sportName: "Serie A", ScoreKey: "Serie A", OddKey: "soccer_italy_serie_a", PredictionKey: "Serie A", seasonName: "NFL", sportID: 1),
        SportMenuItemModel(id: 12,sportName: "Bundesliga", ScoreKey: "Bundesliga", OddKey: "soccer_germany_bundesliga", PredictionKey: "Bundesliga", seasonName: "NFL", sportID: 1),
        SportMenuItemModel(id: 13,sportName: "MLS", ScoreKey: "MLS", OddKey: "soccer_usa_mls", PredictionKey: "Major League Soccer", seasonName: "NFL", sportID: 1),]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(sportMenuArray, id: \.id) { item in
                    SportMenuItem(sportName: item.sportName, ScoreKey: item.ScoreKey, OddKey: item.OddKey, PredictionKey: item.PredictionKey, seasonName: item.seasonName, sportID: item.sportID, logoFetcher: logoFetcher)
                        .environmentObject(settings)
                }
            }
            .navigationTitle("Sports")
            .contentMargins(.top, 20)
            .contentMargins(.bottom, 20)
        }
    }
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
    
    var body: some View {
        NavigationLink(destination: SportPlaceholderPage(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, seasonName: seasonName, sportID: sportID, logoFetcher: logoFetcher)
            .environmentObject(settings)) {
                HStack {
                    Image(sportName + "Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
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
    
    var body: some View {
        SportTabBar(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, seasonName: seasonName, sportID: sportID, logoFetcher: logoFetcher)
            .environmentObject(settings)
    }
}

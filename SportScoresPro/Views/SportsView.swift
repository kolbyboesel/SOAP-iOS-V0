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
    @EnvironmentObject var settings: UserSettings
    @State private var isItemSelected = false
    
    let sportMenuArray: [SportMenuItemModel] = [
        SportMenuItemModel(id: 1, sportName: "NFL", ScoreKey: "NFL 23/24", OddKey: "americanfootball_nfl", PredictionKey: "football", sportID: 63),
        SportMenuItemModel(id: 2,sportName: "NBA",  ScoreKey: "NBA 23/24", OddKey: "basketball_nba", PredictionKey: "basketball", sportID: 2),
        SportMenuItemModel(id: 3,sportName: "MLB", ScoreKey: "MLB 24/25", OddKey: "baseball_mlb", PredictionKey: "baseball", sportID: 64),
        SportMenuItemModel(id: 4,sportName: "NHL", ScoreKey: "NHL 23/24", OddKey: "icehockey_nhl", PredictionKey: "icehockey", sportID: 4),
        SportMenuItemModel(id: 5,sportName: "College Football", ScoreKey: "NCAA Division I, FBS Post Season 23/24", OddKey: "americanfootball_ncaaf", PredictionKey: "football", sportID: 63),
        SportMenuItemModel(id: 6,sportName: "College Basketball", ScoreKey: "NCAA, Regular Season 23/24", OddKey: "basketball_ncaab", PredictionKey: "basketball", sportID: 2),
        SportMenuItemModel(id: 7,sportName: "College Baseball", ScoreKey: "NCAARegularSeason", OddKey: "baseball_ncaa", PredictionKey: "baseball", sportID: 64),
        SportMenuItemModel(id: 8,sportName: "Premier League", ScoreKey: "Premier League 23/24", OddKey: "soccer_epl", PredictionKey: "football", sportID: 1),
        SportMenuItemModel(id: 9,sportName: "LaLiga Santander", ScoreKey: "LaLiga 23/24", OddKey: "soccer_spain_la_liga", PredictionKey: "football", sportID: 1),
        SportMenuItemModel(id: 10,sportName: "Ligue 1", ScoreKey: "Ligue 1 23/24", OddKey: "soccer_france_ligue_one", PredictionKey: "football", sportID: 1),
        SportMenuItemModel(id: 11,sportName: "Serie A", ScoreKey: "Serie A 23/24", OddKey: "soccer_italy_serie_a", PredictionKey: "football", sportID: 1),
        SportMenuItemModel(id: 12,sportName: "Bundesliga", ScoreKey: "Bundesliga 23/24", OddKey: "soccer_germany_bundesliga", PredictionKey: "football", sportID: 1),
        SportMenuItemModel(id: 13,sportName: "MLS", ScoreKey: "MLS 23/24", OddKey: "soccer_usa_mls", PredictionKey: "football", sportID: 1),]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(sportMenuArray, id: \.id) { item in
                    SportMenuItem(sportName: item.sportName, ScoreKey: item.ScoreKey, OddKey: item.OddKey, PredictionKey: item.PredictionKey, sportID: item.sportID, logoFetcher: logoFetcher, settings: settings)
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
    var sportID : Int
}

struct SportMenuItem: View{
    var sportName: String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var sportID : Int
    var logoFetcher : LogoFetcher
    
    @ObservedObject var settings: UserSettings

    
    @State private var selectedView: SelectedView = .scores
    
    var body: some View {
        NavigationLink(destination: SportPlaceholderPage(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, sportID: sportID, logoFetcher: logoFetcher, settings: settings)) {
            HStack {
                Image(sportName + "Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 60, maxHeight: 30)
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
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
    var sportID : Int
    var logoFetcher : LogoFetcher
    @ObservedObject var settings: UserSettings
    
    @State private var selectedView: SelectedView = .scores
    
    var body: some View {
        NavigationStack {
            VStack {
                switch selectedView {
                case .scores:
                    SportScoresView(sportName: sportName, seasonName: ScoreKey, sportID: sportID, logoFetcher: logoFetcher)
                case .odds:
                    SportOddsView(sportName: sportName, APIKEY: OddKey, sportID: sportID, logoFetcher: logoFetcher)
                case .predictions:
                    SportPredictionView(sportName: sportName, APIKEY: PredictionKey, sportID: sportID, seasonName: ScoreKey, logoFetcher: logoFetcher)
                }
                Spacer()
            }
            .navigationTitle("Sports")
            .toolbar {
                ToolbarItem() {
                    Menu {
                        Button("Scores") {
                            selectedView = .scores
                        }
                        Button("Odds") {
                            selectedView = .odds
                        }
                        if settings.loggedIn {
                            Button("Predictions") {
                                selectedView = .predictions
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.down.app")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Spacer()
                }
            }
            .contentMargins(.top, 20)
        }
        .accentColor(.white)
    }
}

enum SelectedView {
    case scores, odds, predictions
}

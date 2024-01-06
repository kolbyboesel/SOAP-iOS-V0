//
//  SportsView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/2/24.
//

import Foundation
import SwiftUI

struct FavoritesSelection: View {
    @EnvironmentObject var settings: UserSettings
    @State private var selectedSports = Set<Int>()
    
    @Environment(\.presentationMode) var presentationMode
    
    
    let sportMenuArray: [SportMenuItemModel] = [
        SportMenuItemModel(id: 1, sportName: "NFL", ScoreKey: "NFL", OddKey: "americanfootball_nfl", PredictionKey: "football", seasonName: "NFL", sportID: 63),
        SportMenuItemModel(id: 2,sportName: "NBA",  ScoreKey: "NBA", OddKey: "basketball_nba", PredictionKey: "basketball", seasonName: "NBA", sportID: 2),
        SportMenuItemModel(id: 3,sportName: "MLB", ScoreKey: "MLB", OddKey: "baseball_mlb", PredictionKey: "baseball", seasonName: "MLB", sportID: 64),
        SportMenuItemModel(id: 4,sportName: "NHL", ScoreKey: "NHL", OddKey: "icehockey_nhl", PredictionKey: "icehockey", seasonName: "NHL",sportID: 4),
        SportMenuItemModel(id: 5,sportName: "College Football", ScoreKey: "NCAA Division I, FBS Post Season", OddKey: "americanfootball_ncaaf", PredictionKey: "football", seasonName: "NCAA Men",sportID: 63),
        SportMenuItemModel(id: 6,sportName: "College Basketball", ScoreKey: "NCAA Men", OddKey: "basketball_ncaab", PredictionKey: "basketball", seasonName: "NCAA Men",sportID: 2),
        SportMenuItemModel(id: 7,sportName: "College Baseball", ScoreKey: "NCAA Men", OddKey: "baseball_ncaa", PredictionKey: "baseball", seasonName: "NCAA Men",sportID: 64),
        SportMenuItemModel(id: 8,sportName: "Premier League", ScoreKey: "Premier League", OddKey: "soccer_epl", PredictionKey: "football", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 9,sportName: "LaLiga Santander", ScoreKey: "LaLiga", OddKey: "soccer_spain_la_liga", PredictionKey: "football", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 10,sportName: "Ligue 1", ScoreKey: "Ligue 1", OddKey: "soccer_france_ligue_one", PredictionKey: "football", seasonName: "NFL",sportID: 1),
        SportMenuItemModel(id: 11,sportName: "Serie A", ScoreKey: "Serie A", OddKey: "soccer_italy_serie_a", PredictionKey: "football", seasonName: "NFL", sportID: 1),
        SportMenuItemModel(id: 12,sportName: "Bundesliga", ScoreKey: "Bundesliga", OddKey: "soccer_germany_bundesliga", PredictionKey: "football", seasonName: "NFL", sportID: 1),
        SportMenuItemModel(id: 13,sportName: "MLS", ScoreKey: "MLS", OddKey: "soccer_usa_mls", PredictionKey: "football", seasonName: "NFL", sportID: 1),]
    
    var body: some View {
        VStack {
            List(sportMenuArray, id: \.id) { item in
                HStack {
                    Text(item.sportName)
                    Spacer()
                    Toggle("", isOn: self.binding(for: item.id))
                }
            }
            
            Button("Confirm") {
                updateFavorites()
            }
            .padding()
            .background(Color.SportScoresRed)
            .foregroundColor(Color.white)
            .cornerRadius(10)
        }
        .contentMargins(.top, 20)
        .contentMargins(.bottom, 20)
        .navigationTitle("Favorites")
        .accentColor(.white)
        .onAppear {
                    // Populate the selectedSports set with IDs from userFavorites
                    selectedSports = Set(settings.userFavorites.map { $0.id })
                }
    }
    private func binding(for id: Int) -> Binding<Bool> {
        return .init(
            get: { self.selectedSports.contains(id) },
            set: {
                if $0 {
                    self.selectedSports.insert(id)
                } else {
                    self.selectedSports.remove(id)
                }
            }
        )
    }
    
    private func updateFavorites() {
        let selectedFavorites = sportMenuArray.filter { selectedSports.contains($0.id) }
        settings.userFavorites = selectedFavorites
        self.presentationMode.wrappedValue.dismiss()
    }
}

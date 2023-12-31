//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct PredictionView: View {
    @EnvironmentObject var settings: UserSettings
    @State var notificationToggle: Bool = false
    @State var locationUsage: Bool = false
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        return AnyView(PredictionMenu())
        
    }
    
}

struct PredictionMenu: View {
    @EnvironmentObject var settings: UserSettings
    
    let PredictionMenuArray: [PredictionMenuItemModel] = [
        PredictionMenuItemModel(id: 1, sportName: "NFL", APIKEY: "football", sportID: 63, seasonName: "NFL"),
        PredictionMenuItemModel(id: 2,sportName: "NBA", APIKEY: "basketball", sportID: 2, seasonName: "NBA"),
        PredictionMenuItemModel(id: 3,sportName: "MLB", APIKEY: "baseball", sportID: 64, seasonName: "MLB"),
        PredictionMenuItemModel(id: 4,sportName: "NHL", APIKEY: "icehockey", sportID: 4, seasonName: "NHL"),
        PredictionMenuItemModel(id: 5,sportName: "College Football", APIKEY: "football", sportID: 63, seasonName: "NCAA Men"),
        PredictionMenuItemModel(id: 6,sportName: "College Basketball", APIKEY: "basketball", sportID: 2, seasonName: "NCAA Men"),
        PredictionMenuItemModel(id: 7,sportName: "College Baseball", APIKEY: "baseball", sportID: 64, seasonName: "NCAA Men"),
        PredictionMenuItemModel(id: 8,sportName: "Premier League", APIKEY: "soccer_epl", sportID: 1, seasonName: "England Premier League"),
        PredictionMenuItemModel(id: 9,sportName: "LaLiga Santander", APIKEY: "soccer_spain_la_liga", sportID: 1, seasonName: "NBA"),
        PredictionMenuItemModel(id: 10,sportName: "Ligue 1", APIKEY: "soccer_france_ligue_onee", sportID: 1, seasonName: "NBA"),
        PredictionMenuItemModel(id: 11,sportName: "Serie A", APIKEY: "soccer_italy_serie_a", sportID: 1, seasonName: "Italy Serie A"),
        PredictionMenuItemModel(id: 12,sportName: "Bundesliga", APIKEY: "soccer_germany_bundesliga", sportID: 1, seasonName: "NBA"),
        PredictionMenuItemModel(id: 13,sportName: "MLS", APIKEY: "soccer_usa_mls", sportID: 1, seasonName: "MLS"),]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(PredictionMenuArray, id: \.id) { item in
                    PredictionMenuItem(sportName: item.sportName, APIKEY: item.APIKEY, sportID: item.sportID, seasonName: item.seasonName)
                }
            }
            .navigationTitle("Betting Predictions")
            .contentMargins(.top, 20)
        }
        .accentColor(.white)
    }
}

struct SportPredictionView: View {
    @State private var predictionData: [PredictionData] = []
    @State private var selectedDate = Date()
    var sportName: String
    var APIKEY : String
    var sportID: Int
    var seasonName : String
    @State private var isLoading = false
    @State var market = "Moneyline"
    @State var isMenuVisible = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    let menuItems = ["Moneyline", "Spreads", "Over / Unders"]
                    
                    PredictionMenuButton(isMenuVisible: $isMenuVisible, market: $market)
                    
                    if isMenuVisible {
                        PredictionDropdownMenu(menuItems: menuItems, market: $market, isMenuVisible: $isMenuVisible)
                    }
                    
                    List{
                        ForEach(predictionData, id: \.match_id) { data in
                            let startTime = formatEventTime(epochTIS: TimeInterval(data.match_dat))
                            let startDate = formatEventDate(epochTIS: TimeInterval(data.match_dat))
                            let selectedFormattedDate = formatVerifyDate(date: selectedDate)
                            let verifyDate = startDate == selectedFormattedDate
                            
                            if(data.league_name == seasonName && verifyDate){
                                VStack {
                                    PredictionHeader(startDate: startDate, startTime: startTime, market: $market)
                                    
                                    PredictionBoard(market: $market, data: data)
                                }
                            }
                        }
                    }
                    .navigationTitle("\(sportName)")
                    .navigationBarTitleDisplayMode(.inline)
                    .accentColor(.white)
                }
            }
            .onAppear {
                isLoading = true
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayDate = dateFormatter.string(from: Date())
                
                let currentDate = Date()
                var nextDateString = " "
                if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                    nextDateString = dateFormatter.string(from: nextDate)
                } else {
                    print("Could not calculate the next date.")
                }
                
                getPredictionData(forSport: APIKEY, forSport: sportID, selectedDate: todayDate, seasonName: seasonName) { fetchedData in
                    self.predictionData = fetchedData
                    getPredictionData(forSport: APIKEY, forSport: sportID, selectedDate: nextDateString, seasonName: seasonName) { nextDayData in
                            self.predictionData.append(contentsOf: nextDayData)
                            self.isLoading = false
                        }
                }
            }
        }
    }
}

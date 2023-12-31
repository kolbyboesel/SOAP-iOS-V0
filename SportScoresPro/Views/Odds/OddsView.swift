//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct OddsView: View {
    @EnvironmentObject var settings: UserSettings
    @State var notificationToggle: Bool = false
    @State var locationUsage: Bool = false
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        return AnyView(OddsMenu())
        
    }
    
}

struct OddsMenu: View {
    @EnvironmentObject var settings: UserSettings
    
    let oddsMenuArray: [OddsMenuItemModel] = [
        OddsMenuItemModel(id: 1, sportName: "NFL", APIKEY: "americanfootball_nfl", sportID: 63),
        OddsMenuItemModel(id: 2,sportName: "NBA", APIKEY: "basketball_nba", sportID: 2),
        OddsMenuItemModel(id: 3,sportName: "MLB", APIKEY: "baseball_mlb", sportID: 64),
        OddsMenuItemModel(id: 4,sportName: "NHL", APIKEY: "icehockey_nhl", sportID: 4),
        OddsMenuItemModel(id: 5,sportName: "College Football", APIKEY: "americanfootball_ncaaf", sportID: 63),
        OddsMenuItemModel(id: 6,sportName: "College Basketball", APIKEY: "basketball_ncaab", sportID: 2),
        OddsMenuItemModel(id: 7,sportName: "College Baseball", APIKEY: "baseball_ncaa", sportID: 64),
        OddsMenuItemModel(id: 8,sportName: "Premier League", APIKEY: "soccer_epl", sportID: 1),
        OddsMenuItemModel(id: 9,sportName: "LaLiga Santander", APIKEY: "soccer_spain_la_liga", sportID: 1),
        OddsMenuItemModel(id: 10,sportName: "Ligue 1", APIKEY: "soccer_france_ligue_onee", sportID: 1),
        OddsMenuItemModel(id: 11,sportName: "Serie A", APIKEY: "soccer_italy_serie_a", sportID: 1),
        OddsMenuItemModel(id: 12,sportName: "Bundesliga", APIKEY: "soccer_germany_bundesliga", sportID: 1),
        OddsMenuItemModel(id: 13,sportName: "MLS", APIKEY: "soccer_usa_mls", sportID: 1),]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(oddsMenuArray, id: \.id) { item in
                    OddsMenuItem(sportName: item.sportName, APIKEY: item.APIKEY, sportID: item.sportID)
                }
            }
            .navigationTitle("Betting Odds")
            .contentMargins(.top, 20)
        }
        .accentColor(.white)
    }
}

struct SportOddsView: View {
    @State private var oddsData: [OddsData] = []
    @State private var selectedDate = Date()
    var sportName: String
    var APIKEY: String
    var sportID: Int
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
                    
                    OddsMenuButton(isMenuVisible: $isMenuVisible, market: $market)
                    
                    if isMenuVisible {
                        OddsDropdownMenu(menuItems: menuItems, market: $market, isMenuVisible: $isMenuVisible)
                    }
                    
                    List{
                        ForEach(oddsData, id: \.id) { data in
                            let startTime = formatEventTime(epochTIS: TimeInterval(data.commence_time))
                            let startDate = formatEventDate(epochTIS: TimeInterval(data.commence_time))
                            VStack {
                                
                                OddsHeader(startDate: startDate, startTime: startTime, market: $market)
                                
                                OddBoard(market: $market, data: data)
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
                
                getOddsData(forSport: APIKEY, forSport: sportID, selectedDate: todayDate) { fetchedData in
                    self.oddsData = fetchedData
                    self.isLoading = false
                    
                }
            }
        }
    }
}

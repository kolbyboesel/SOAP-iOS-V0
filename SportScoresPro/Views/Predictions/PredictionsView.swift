//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct SportPredictionView: View {
    @State private var predictionData: [PredictionData] = []
    @State private var selectedDate = Date()
    var sportName: String
    var APIKEY : String
    var sportID: Int
    var seasonName : String
    var logoFetcher : LogoFetcher
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
                                    
                                    PredictionBoard(market: $market, data: data, logoFetcher: logoFetcher)
                                }
                            }
                        }
                    }
                    .navigationTitle("\(sportName)" + " Predictions")
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

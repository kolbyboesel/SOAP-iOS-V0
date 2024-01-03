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
    var PredictionKey : String
    var sportID: Int
    var seasonName : String
    @ObservedObject var logoFetcher : LogoFetcher
    @State private var isLoading = false
    @State var market = "Moneyline"
    @State var isMenuVisible = false
    @EnvironmentObject var settings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    
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
                    
                    if settings.loggedIn {
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
                    } else {
                        
                        Text("Please log in or create an account to access all predictions")
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color.SportScoresRed)
                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Spacer()
                        if let firstPrediction = predictionData.first {
                            let startTime = formatEventTime(epochTIS: TimeInterval(firstPrediction.match_dat))
                            let startDate = formatEventDate(epochTIS: TimeInterval(firstPrediction.match_dat))
                            let selectedFormattedDate = formatVerifyDate(date: selectedDate)
                            let verifyDate = startDate == selectedFormattedDate
                            if(firstPrediction.league_name == seasonName && verifyDate){
                                List {
                                    VStack {
                                        PredictionHeader(startDate: startDate, startTime: startTime, market: $market)
                                        
                                        PredictionBoard(market: $market, data: firstPrediction, logoFetcher: logoFetcher)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(sportName) Predictions")
            .padding(.bottom, 60)
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
                
                getPredictionData(forSport: PredictionKey, forSport: sportID, selectedDate: todayDate, seasonName: seasonName) { fetchedData in
                    self.predictionData = fetchedData
                    getPredictionData(forSport: PredictionKey, forSport: sportID, selectedDate: nextDateString, seasonName: seasonName) { nextDayData in
                        self.predictionData.append(contentsOf: nextDayData)
                        self.isLoading = false
                    }
                }
            }
        }
    }
}

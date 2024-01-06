//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct SportPredictionView: View {
    var PredictionKey : String
    var sportID: Int
    var seasonName : String
    @Binding var market : String
    @ObservedObject var logoFetcher: LogoFetcher
    @EnvironmentObject var settings: UserSettings

    @State private var predictionData: [PredictionData] = []
    var usablePredData: [PredictionData] = []
    @State private var isLoading = false
    

    var body: some View {
        VStack(){
            if isLoading {
                ProgressView("Loading...")
            } else {
                if settings.loggedIn {
                    List{
                        let filteredData = filteredPredictionData(for: predictionData, seasonName: seasonName, selectedDate: Date())
                        
                        ForEach(filteredData.indices, id: \.self) { index in
                            
                            let data = filteredData[index]
                            
                            let startTime = formatEventTime(epochTIS: TimeInterval(data.match_dat))
                            let startDate = formatEventDate(epochTIS: TimeInterval(data.match_dat))
                            
                            VStack {
                                PredictionHeader(startDate: startDate, startTime: startTime)
                                
                                PredictionBoard(logoFetcher: logoFetcher, data: data, sportID: sportID)
                                
                                if index != filteredData.count - 1 {
                                    SportDivider(color: .secondary, width: 2)
                                }
                            }
                            
                        }
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)
                    }
                    .contentMargins(.top, 20)
                    .contentMargins(.bottom, 20)
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
                        let selectedFormattedDate = formatVerifyDate(date: Date())
                        let verifyDate = startDate == selectedFormattedDate
                        if(firstPrediction.league_name == seasonName && verifyDate){
                            List {
                                VStack {
                                    PredictionHeader(startDate: startDate, startTime: startTime)
                                    
                                    PredictionBoard(logoFetcher: logoFetcher, data: firstPrediction, sportID: sportID)
                                }
                            }
                            
                        }
                    }
                }
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

func filteredPredictionData(for predictionData: [PredictionData], seasonName: String, selectedDate: Date) -> [PredictionData] {
    let selectedFormattedDate = formatVerifyDate(date: selectedDate)
    return predictionData.filter { data in
        let startDate = formatEventDate(epochTIS: TimeInterval(data.match_dat))
        return data.league_name == seasonName && startDate == selectedFormattedDate
    }
}

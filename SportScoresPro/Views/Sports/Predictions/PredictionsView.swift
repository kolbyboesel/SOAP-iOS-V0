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
    @State private var soccerPredictionData: [SoccerPredictionData] = []
    
    @State private var isLoading = false
    
    
    var body: some View {
        VStack(){
            if isLoading {
                ProgressView("Loading...")
            } else {
                if settings.loggedIn {
                    if sportID != 1 {
                        let filteredData = filteredPredictionData(for: predictionData, seasonName: seasonName, selectedDate: Date())
                        
                        if(filteredData.count == 0){
                            Text("No Data Currently Available")
                                .font(.headline)
                                .bold()
                                .foregroundColor(Color.SportScoresRed)
                                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        
                        List{
                            
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
                        let filteredData = filteredSoccerPredictionData(for: soccerPredictionData, seasonName: PredictionKey)
                        
                        if(filteredData.count == 0){
                            Text("No Data Currently Available")
                                .font(.headline)
                                .bold()
                                .foregroundColor(Color.SportScoresRed)
                                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        
                        List{
                            
                            ForEach(filteredData.indices, id: \.self) { index in
                                
                                let data = filteredData[index]
                                
                                
                                let startDate = data.date
                                
                                VStack {
                                    SoccerPredictionHeader(startDate: startDate)
                                    
                                    SoccerPredictionBoard(logoFetcher: logoFetcher, data: data, sportID: sportID)
                                    
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
                }
            }
        }
        .onAppear {
            isLoading = true
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDate = dateFormatter.string(from: Date())
            
            if(sportID != 1){
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
            } else {
                getSoccerPredictionData(forSport: PredictionKey, forSport: sportID, selectedDate: todayDate, seasonName: seasonName) { fetchedData in
                    self.soccerPredictionData = fetchedData
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

func filteredSoccerPredictionData(for soccerPredictionData: [SoccerPredictionData], seasonName: String) -> [SoccerPredictionData]
{
    var country = ""
    if(seasonName == "Major League Soccer") {
        country = "USA"
    }
    if(seasonName == "Ligue 1") {
        country = "France"
    }
    if(seasonName == "Premier League") {
        country = "England"
    }
    if(seasonName == "Bundesliga") {
        country = "Germany"

    }
    if(seasonName == "La Liga") {
        country = "Spain"
    }
    if(seasonName == "Serie A") {
        country = "Italy"
    }
    
    return soccerPredictionData.filter { data in
        return data.competition == seasonName && data.country == country
    }
}

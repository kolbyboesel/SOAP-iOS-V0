//
//  FavoritesSubViews.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct FavoriteScoresView: View {
    var ScoreKey: String
    var sportID: Int
    @ObservedObject var logoFetcher : LogoFetcher

    @State private var liveScoreData: [LiveScoreData] = []
    @State private var selectedDate = Date()
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0){
            if isLoading {
                ProgressView("Loading...")
            } else {
                VStack(spacing: 0) {
                    
                    if(liveScoreData.count == 0){
                        Text("No Data Currently Available")
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color.SportScoresRed)
                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    List {
                        ForEach(liveScoreData.indices, id: \.self) { index in
                            
                            let data = liveScoreData[index]
                            
                            let formattedDate = formatEventDate(epochTIS: data.startTimestamp)
                            let formattedTime = formatEventTime(epochTIS: data.startTimestamp)
                            let selectedFormattedDate = formatVerifyDate(date: selectedDate)
                            let verifyDate = formattedDate == selectedFormattedDate
                            
                            if verifyDate == true {
                                VStack {
                                    ScoresHeader(data: data, formattedDate: formattedDate, formattedTime: formattedTime, sportID: sportID)
                                    Spacer(minLength: 20)
                                    if data.status.description == "Not started"{
                                        ScoreFuture(logoFetcher: logoFetcher, data: data)
                                    } else {
                                        ScoreLive(logoFetcher: logoFetcher, data: data)
                                    }
                                    if index != liveScoreData.count - 1 {
                                        SportDivider(color: .secondary, width: 2)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listSectionSeparator(.hidden)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .contentMargins(.top, 20)
                    .contentMargins(.bottom, 20)
                }
            }
        }
        .onAppear {
            isLoading = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDate = dateFormatter.string(from: Date())
            
            getScoresData(forSport: ScoreKey, forSport: sportID, selectedDate: todayDate) { fetchedData in
                self.liveScoreData = fetchedData
                isLoading = false
                
            }
        }
        .onDisappear {
        }
    }
}

struct FavoriteOddsView: View {
    var OddKey: String
    var sportID: Int
    @Binding var market : String
    @ObservedObject var logoFetcher : LogoFetcher

    @State private var isLoading = false
    @State private var oddsData: [OddsData] = []
    
    var body: some View {
        VStack(){
            if isLoading {
                ProgressView("Loading...")
            } else {
                
                if(oddsData.count == 0){
                    Text("No Data Currently Available")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.SportScoresRed)
                        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                List{
                    ForEach(oddsData.indices, id: \.self) { index in
                        let data = oddsData[index]

                        let startTime = formatEventTime(epochTIS: TimeInterval(data.commence_time))
                        let startDate = formatEventDate(epochTIS: TimeInterval(data.commence_time))
                        VStack {
                            OddsHeader(market: $market, startDate: startDate, startTime: startTime)
                            Spacer(minLength: 20)

                            OddBoard(logoFetcher: logoFetcher, market: $market, data: data)
                            
                            if index != oddsData.count - 1 {
                                SportDivider(color: .secondary, width: 2)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                }
                .listStyle(.plain)
                .contentMargins(.top, 20)
                .contentMargins(.bottom, 20)
            }
        }
        .onAppear {
            isLoading = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDate = dateFormatter.string(from: Date())
            
            getOddsData(forSport: OddKey, forSport: sportID, selectedDate: todayDate) { fetchedData in
                self.oddsData = fetchedData
                self.isLoading = false
                
            }
        }
    }
}

struct FavoritePredictionView: View {
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
                                
                                Spacer(minLength: 20)

                            
                                PredictionBoard(logoFetcher: logoFetcher, data: data, sportID: sportID)
                                
                                if index != filteredData.count - 1 {
                                    SportDivider(color: .secondary, width: 2)
                                }
                            }
                            
                        }
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)
                    }
                    .listStyle(.plain)
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

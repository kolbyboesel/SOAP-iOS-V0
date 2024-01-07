//
//  LiveView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/4/24.
//

import SwiftUI
import Foundation

struct LiveScoresView: View {
    var sportID : Int
    @ObservedObject var logoFetcher : LogoFetcher
    
    @State private var AllLiveScoreData: [LiveScoreData] = []
    
    @State private var selectedDate = Date()
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0){
            if isLoading {
                ProgressView("Loading...")
            } else {
                VStack(spacing: 0) {
                    let filteredData = filteredLiveData(sportID: sportID, for: AllLiveScoreData)
                    
                    if(filteredData.count == 0){
                        Text("No Data Currently Available")
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color.SportScoresRed)
                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    List {
                        if(sportID != 1){
                            
                            ForEach(filteredData.indices, id: \.self) { index in
                                
                                let data = filteredData[index]
                                
                                let formattedDate = formatEventDate(epochTIS: data.startTimestamp)
                                let formattedTime = formatEventTime(epochTIS: data.startTimestamp)
                                
                                VStack {
                                    ScoresHeader(data: data, formattedDate: formattedDate, formattedTime: formattedTime, sportID: sportID)
                                    if data.status.description == "Not started"{
                                        ScoreFuture(logoFetcher: logoFetcher, data: data)
                                    } else {
                                        ScoreLive(logoFetcher: logoFetcher, data: data)
                                    }
                                    
                                    if index != filteredData.count - 1 {
                                        SportDivider(color: .secondary, width: 2)
                                    }
                                    
                                }
                                .listRowSeparator(.hidden)
                                .listSectionSeparator(.hidden)
                            }
                        } else {
                            ForEach(AllLiveScoreData.indices, id: \.self) { index in
                                let data = AllLiveScoreData[index]
                                
                                let formattedDate = formatEventDate(epochTIS: data.startTimestamp)
                                let formattedTime = formatEventTime(epochTIS: data.startTimestamp)
                                
                                VStack {
                                    ScoresHeader(data: data, formattedDate: formattedDate, formattedTime: formattedTime, sportID: sportID)
                                    
                                    if data.status.description == "Not started"{
                                        ScoreFuture(logoFetcher: logoFetcher, data: data)
                                    } else {
                                        ScoreLive(logoFetcher: logoFetcher, data: data)
                                    }
                                    if index != AllLiveScoreData.count - 1 {
                                        SportDivider(color: .secondary, width: 2)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listSectionSeparator(.hidden)
                            }
                        }
                    }
                    .contentMargins(.top, 20)
                    .contentMargins(.bottom, 20)
                }
            }
        }
        .onAppear {
            isLoading = true
            
            getLiveScoresData(forSport: sportID) { data in
                self.AllLiveScoreData = data
                isLoading = false
            }
        }
        .onDisappear {
        }
    }
}
    
func filteredLiveData(sportID: Int, for predictionData: [LiveScoreData]) -> [LiveScoreData] {
    if(sportID == 1){
        return predictionData
    } else {
        return predictionData.filter { data in
            return ((data.tournament?.category?.name ?? "") == "USA")
        }
    }
}

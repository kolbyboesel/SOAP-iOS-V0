//
//  TeamSubView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/7/24.
//

import Foundation
import SwiftUI

struct TeamScoresView: View {
    var team : SearchData
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
            
            getTeamEvents(forSport: team.id, eventType: "last") { fetchedData in
                self.liveScoreData = fetchedData
                print("Last events: \(self.liveScoreData)")
                
                getTeamEvents(forSport: team.id, eventType: "next") { fetchedData in
                    self.liveScoreData.append(contentsOf: fetchedData)
                    print("Updated with next events: \(self.liveScoreData)")
                    isLoading = false
                }
            }
        }
        .onDisappear {
        }
    }
}

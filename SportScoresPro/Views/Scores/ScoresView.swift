//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI
import Foundation

struct SportScoresView: View {
    @State private var liveScoreData: [LiveScoreData] = []
    @State private var selectedDate = Date()
    var sportName: String
    var ScoreKey: String
    var sportID: Int
    @State private var isLoading = false
    @ObservedObject var logoFetcher : LogoFetcher
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @EnvironmentObject var settings: UserSettings
    
    
    var body: some View {
        VStack(spacing: 0){
            if isLoading {
                ProgressView("Loading...")
            } else {
                VStack(spacing: 0) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .font(.system(size: 15))
                        .datePickerStyle(.compact)
                        .onChange(of: selectedDate) { newDate in
                            isLoading = true
                            let dateString = formatDateToString(date: newDate)
                            getScoresData(forSport: ScoreKey, forSport: sportID, selectedDate: dateString) { fetchedData in
                                self.liveScoreData = fetchedData
                                isLoading = false
                            }
                        }
                        .accentColor(.SportScoresRed)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom, 10)
                        .padding(.top, 10)


                    
                    Divider()
                    
                    List(liveScoreData) { data in
                        
                        let formattedDate = formatEventDate(epochTIS: data.startTimestamp)
                        let formattedTime = formatEventTime(epochTIS: data.startTimestamp)
                        let selectedFormattedDate = formatVerifyDate(date: selectedDate)
                        let verifyDate = formattedDate == selectedFormattedDate
                        
                        if verifyDate == true {
                            VStack {
                                ScoresHeader(data: data, formattedDate: formattedDate, formattedTime: formattedTime)
                                if data.status.description == "Not started"{
                                    ScoreFuture(data: data, logoFetcher: logoFetcher)
                                } else {
                                    ScoreLive(data: data, logoFetcher: logoFetcher)
                                }
                            }
                        }
                    }
                    .contentMargins(.top, 20)
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

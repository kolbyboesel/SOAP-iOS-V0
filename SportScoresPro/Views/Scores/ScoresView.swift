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
    
    var body: some View {
        VStack{
            if isLoading {
                ProgressView("Loading...")
            } else {
                ZStack(alignment: .bottom) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .padding()
                        .datePickerStyle(.automatic)
                        .onChange(of: selectedDate) { newDate in
                            isLoading = true
                            let dateString = formatDateToString(date: newDate)
                            getScoresData(forSport: ScoreKey, forSport: sportID, selectedDate: dateString) { fetchedData in
                                self.liveScoreData = fetchedData
                                isLoading = false
                            }
                        }
                        .accentColor(.blue)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.SportScoresRed)
                        .offset(y: 5)
                    
                }
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
            }
        }
        .padding(.bottom, 60)
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

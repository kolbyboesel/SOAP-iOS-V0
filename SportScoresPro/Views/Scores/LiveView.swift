//
//  LiveView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/4/24.
//

import SwiftUI
import Foundation

struct LiveScoresView: View {
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
                    List(AllLiveScoreData) { data in
                        
                        let formattedDate = formatEventDate(epochTIS: data.startTimestamp)
                        let formattedTime = formatEventTime(epochTIS: data.startTimestamp)
                        let selectedFormattedDate = formatVerifyDate(date: selectedDate)
                        let verifyDate = formattedDate == selectedFormattedDate
                        
                        if verifyDate == true {
                            VStack {
                                ScoresHeader(data: data, formattedDate: formattedDate, formattedTime: formattedTime)
                                if data.status.description == "Not started"{
                                    ScoreFuture(logoFetcher: logoFetcher, data: data)
                                } else {
                                    ScoreLive(logoFetcher: logoFetcher, data: data)
                                }
                            }
                        }
                    }
                    .navigationTitle("Live Scores")
                    .navigationBarTitleDisplayMode(.inline)
                    .contentMargins(.top, 20)
                    .contentMargins(.bottom, 20)                }
            }
        }
        .onAppear {
            isLoading = true
            
            getLiveScoresData(forSport: 1) { Soccer in
                self.AllLiveScoreData = Soccer
                getLiveScoresData(forSport: 2) { Basketball in
                    self.AllLiveScoreData.append(contentsOf: Basketball)
                    getLiveScoresData(forSport: 4) { Hockey in
                        self.AllLiveScoreData.append(contentsOf: Hockey)
                        getLiveScoresData(forSport: 63) { Football in
                            self.AllLiveScoreData.append(contentsOf: Football)
                            getLiveScoresData(forSport: 64) { Baseball in
                                self.AllLiveScoreData.append(contentsOf: Baseball)
                                isLoading = false

                            }
                        }
                    }
                }
            }
        }
        .onDisappear {
        }
    }
}

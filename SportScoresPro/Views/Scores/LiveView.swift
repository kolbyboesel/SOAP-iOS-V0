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
                    List(AllLiveScoreData) { data in
                        
                        let formattedDate = formatEventDate(epochTIS: data.startTimestamp)
                        let formattedTime = formatEventTime(epochTIS: data.startTimestamp)
                        let selectedFormattedDate = formatVerifyDate(date: selectedDate)
                        let verifyDate = formattedDate == selectedFormattedDate
                        
                        if(sportID != 1){
                            if verifyDate == true && ((data.tournament?.category?.name ?? "") == "USA") {
                                VStack {
                                    ScoresHeader(data: data, formattedDate: formattedDate, formattedTime: formattedTime, sportID: sportID)
                                    if data.status.description == "Not started"{
                                        ScoreFuture(logoFetcher: logoFetcher, data: data)
                                    } else {
                                        ScoreLive(logoFetcher: logoFetcher, data: data)
                                    }
                                    SportDivider(color: .SportScoresRed, width: 2)

                                }
                                .listRowSeparator(.hidden)
                                .listSectionSeparator(.hidden)
                            }
                        } else {
                            VStack {
                                ScoresHeader(data: data, formattedDate: formattedDate, formattedTime: formattedTime, sportID: sportID)
                                if data.status.description == "Not started"{
                                    ScoreFuture(logoFetcher: logoFetcher, data: data)
                                } else {
                                    ScoreLive(logoFetcher: logoFetcher, data: data)
                                }
                                SportDivider(color: .SportScoresRed, width: 2)

                            }
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden)
                        }
                    }
                    .contentMargins(.top, 20)
                    .contentMargins(.bottom, 20)                }
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

struct LiveTabBar: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(){
            VStack(spacing: 0){
                HStack(spacing: 0) {
                    
                    Spacer()
                    
                    Button(action: { selectedTab = 0 }) {
                        VStack {
                            VStack {
                                Text("Football")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 0 ? .bold : .regular)
                                
                            }
                            if selectedTab == 0 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack {
                            VStack {
                                Text("Basketball")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 1 ? .bold : .regular)
                                
                            }
                            if selectedTab == 1 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 2
                    }) {
                        VStack {
                            VStack {
                                Text("Baseball")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 2 ? .bold : .regular)
                                
                            }
                            if selectedTab == 2 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 3
                    }) {
                        VStack {
                            VStack {
                                Text("Hockey")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 3 ? .bold : .regular)
                                
                            }
                            if selectedTab == 3 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 4
                    }) {
                        VStack {
                            VStack {
                                Text("Soccer")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                                    .fontWeight(selectedTab == 4 ? .bold : .regular)
                                
                            }
                            if selectedTab == 4 {
                                Color.white.frame(height: 3)
                            } else {
                                Color.clear.frame(height: 0)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 0)
                .padding(.top)
                .padding(.leading)
                .padding(.trailing)
                .background(Color.SportScoresRed)
                
                Group {
                    switch selectedTab {
                    case 0:
                        NavigationView{
                            LiveScoresView(sportID: 63, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Football Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 1:
                        NavigationView{
                            LiveScoresView(sportID: 2, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Basketball Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 2:
                        NavigationView{
                            LiveScoresView(sportID: 64, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Baseball Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 3:
                        NavigationView{
                            LiveScoresView(sportID: 4, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Hockey Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 4:
                        NavigationView{
                            LiveScoresView(sportID: 1, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Soccer Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    default:
                        NavigationView{
                            LiveScoresView(sportID: 63, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Football Live")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .zIndex(0)
            }
        }
    }
}

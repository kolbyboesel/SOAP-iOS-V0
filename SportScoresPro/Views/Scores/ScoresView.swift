//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI
import Foundation

struct ScoresView: View {
    @EnvironmentObject var settings: UserSettings
    @State var notificationToggle: Bool = false
    @State var locationUsage: Bool = false
    
    var body: some View {
        return AnyView(ScoresMenu())
    }
}

struct ScoresMenu: View {
    @EnvironmentObject var settings: UserSettings
    @State private var isItemSelected = false
    
    let scoresMenuArray: [ScoreMenuItemModel] = [
        ScoreMenuItemModel(id: 1, sportName: "NFL", seasonName: "NFL 23/24", sportID: 63),
        ScoreMenuItemModel(id: 2,sportName: "NBA", seasonName: "NBA 23/24", sportID: 2),
        ScoreMenuItemModel(id: 3,sportName: "MLB", seasonName: "MLB 24/25", sportID: 64),
        ScoreMenuItemModel(id: 4,sportName: "NHL", seasonName: "NHL 23/24", sportID: 4),
        ScoreMenuItemModel(id: 5,sportName: "College Football", seasonName: "NCAA Division I, FBS Post Season 23/24", sportID: 63),
        ScoreMenuItemModel(id: 6,sportName: "College Basketball", seasonName: "NCAA, Regular Season 23/24", sportID: 2),
        ScoreMenuItemModel(id: 7,sportName: "College Baseball", seasonName: "NCAARegularSeason", sportID: 64),
        ScoreMenuItemModel(id: 8,sportName: "Premier League", seasonName: "Premier League 23/24", sportID: 1),
        ScoreMenuItemModel(id: 9,sportName: "LaLiga Santander", seasonName: "LaLiga 24/25", sportID: 1),
        ScoreMenuItemModel(id: 10,sportName: "Ligue 1", seasonName: "Ligue 1 23/24", sportID: 1),
        ScoreMenuItemModel(id: 11,sportName: "Serie A", seasonName: "Serie A 23/24", sportID: 1),
        ScoreMenuItemModel(id: 12,sportName: "Bundesliga", seasonName: "Bundesliga 23/24", sportID: 1),
        ScoreMenuItemModel(id: 13,sportName: "MLS", seasonName: "MLS 23/24", sportID: 1),]
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(scoresMenuArray, id: \.id) { item in
                    ScoresMenuItem(sportName: item.sportName, seasonName: item.seasonName, sportID: item.sportID)
                }
            }
            .navigationTitle("Scores")
            .contentMargins(.top, 20)
        }
        .accentColor(.white)
    }
}

struct SportScoresView: View {
    @State private var liveScoreData: [LiveScoreData] = []
    @State private var selectedDate = Date()
    var sportName: String
    var seasonName: String
    var sportID: Int
    @State private var teamLogos: [Int: UIImage] = [:]
    @State private var isLoading = false
    @ObservedObject var logoFetcher = LogoFetcher()
    
    
    var body: some View {
        VStack{
            if isLoading {
                ProgressView("Loading...")
            } else {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .padding()
                    .datePickerStyle(.automatic)
                    .onChange(of: selectedDate) { newDate in
                        isLoading = true
                        let dateString = formatDateToString(date: newDate)
                        getScoresData(forSport: seasonName, forSport: sportID, selectedDate: dateString) { fetchedData in
                            self.liveScoreData = fetchedData
                            isLoading = false
                        }
                    }
                    .overlay(
                        Rectangle()
                            .frame(height: 5)
                            .foregroundColor(.SportScoresRed),
                        alignment: .bottom
                    )
                    .accentColor(.blue)
                
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
                .navigationTitle("\(sportName)")
                .navigationBarTitleDisplayMode(.inline)
                .accentColor(.white)
            }
        }
        .onAppear {
            isLoading = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDate = dateFormatter.string(from: Date())
            
            getScoresData(forSport: seasonName, forSport: sportID, selectedDate: todayDate) { fetchedData in
                self.liveScoreData = fetchedData
                isLoading = false
                
            }
        }
    }
}

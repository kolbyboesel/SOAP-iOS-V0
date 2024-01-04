//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct SportOddsView: View {
    @Binding var market : String
    @State private var oddsData: [OddsData] = []
    @State private var selectedDate = Date()
    var sportName: String
    var OddKey: String
    var sportID: Int
    @State private var isLoading = false
    @State var isMenuVisible = false
    @ObservedObject var logoFetcher : LogoFetcher
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedSportViewModel: SharedSportViewModel
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack(){
            if isLoading {
                ProgressView("Loading...")
            } else {
                List{
                    ForEach(oddsData, id: \.id) { data in
                        let startTime = formatEventTime(epochTIS: TimeInterval(data.commence_time))
                        let startDate = formatEventDate(epochTIS: TimeInterval(data.commence_time))
                        VStack {
                            OddsHeader(startDate: startDate, startTime: startTime, market: $market)
                            OddBoard(market: $market, data: data, logoFetcher: logoFetcher)
                        }
                    }
                }
                .contentMargins(.top, 20)
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

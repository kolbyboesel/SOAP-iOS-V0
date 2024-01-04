//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct SportOddsView: View {
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
                List{
                    ForEach(oddsData, id: \.id) { data in
                        let startTime = formatEventTime(epochTIS: TimeInterval(data.commence_time))
                        let startDate = formatEventDate(epochTIS: TimeInterval(data.commence_time))
                        VStack {
                            OddsHeader(market: $market, startDate: startDate, startTime: startTime)
                            OddBoard(logoFetcher: logoFetcher, market: $market, data: data)
                        }
                    }
                }
                .contentMargins(.top, 20)
                .contentMargins(.bottom, 20)            }
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

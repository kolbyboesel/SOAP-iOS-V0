//
//  HomeView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/22/23.
//

import SwiftUI

struct SportOddsView: View {
    @State private var oddsData: [OddsData] = []
    @State private var selectedDate = Date()
    var sportName: String
    var OddKey: String
    var sportID: Int
    @State private var isLoading = false
    @State var market = "Moneyline"
    @State var isMenuVisible = false
    @ObservedObject var logoFetcher : LogoFetcher
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    let menuItems = ["Moneyline", "Spreads", "Over / Unders"]
                    
                    OddsMenuButton(isMenuVisible: $isMenuVisible, market: $market)
                    
                    if isMenuVisible {
                        OddsDropdownMenu(menuItems: menuItems, market: $market, isMenuVisible: $isMenuVisible)
                    }
                    
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
                }
            }
            .padding(.bottom, 60)
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
}

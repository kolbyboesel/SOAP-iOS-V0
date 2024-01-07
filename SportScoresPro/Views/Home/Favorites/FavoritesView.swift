//
//  FavoritesView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct FavoriteSportView: View {
    var id: Int
    var sportName : String
    var ScoreKey: String
    var OddKey: String
    var PredictionKey: String
    var seasonName: String
    var sportID : Int
    @ObservedObject var logoFetcher : LogoFetcher
    
    @EnvironmentObject var settings: UserSettings
    
    @State private var showDropdownBtn = false
    @State private var showOddsDropdown = false
    @State var market = "Moneyline"
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    ZStack {
                        Spacer()
                        
                        Text(sportName)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer()

                        if showDropdownBtn {
                            OddsMenuButton(market: $market, isMenuVisible: $showOddsDropdown)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                        }
                    }
                }
                .padding()
                .background(Color(Color.SportScoresRed))
                
                
                FavoritesTabBar(sportName: sportName, ScoreKey: ScoreKey, OddKey: OddKey, PredictionKey: PredictionKey, seasonName: seasonName, sportID: sportID, logoFetcher: logoFetcher, showDropdownBtn: $showDropdownBtn, market: $market)
                    .environmentObject(settings)
                    .zIndex(0)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            if(showOddsDropdown) {
                VStack {
                    Spacer()
                    OddsDropdownMenu(market: $market, isMenuVisible: $showOddsDropdown)
                }
                .padding(.top, 44)
                .padding(.leading)
                .transition(.move(edge: .top))
                .animation(.default, value: showOddsDropdown)
                .zIndex(1)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

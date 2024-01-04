//
//  OddsStructure.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/30/23.
//

import Foundation
import SwiftUI

struct PredictionBoard : View {
    @ObservedObject var logoFetcher : LogoFetcher
    @Binding var market : String
    var data : PredictionData

    var body: some View {

        VStack {
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: 0, teamName: data.away_team_name) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Text(data.away_team_name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if(market == "Moneyline"){
                    Text("\(Int(data.rank_atw_nt * 100))%")
                        .frame(alignment: .trailing)
                        .font(.caption)
                }
                if(market == "Spreads"){
                    Text("Spread Pred")
                        .frame(alignment: .trailing)
                        .font(.caption)
                }
                if(market == "Totals"){
                    Text("Over / Under Pred")
                        .frame(alignment: .trailing)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: 0, teamName: data.home_team_name) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Text(data.home_team_name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if(market == "Moneyline"){
                    Text("\(Int(data.rank_htw_nt * 100))%")
                        .frame(alignment: .trailing)
                        .font(.caption)
                }
                if(market == "Spreads"){
                    Text("Spread Pred")
                        .frame(alignment: .trailing)
                        .font(.caption)
                }
                if(market == "Totals"){
                    Text("Over / Under Pred")
                        .frame(alignment: .trailing)
                        .font(.caption)
                }
            }
        }
        .padding()
    }
}

struct PredictionMenuButton: View{
    @Binding var market : String
    @Binding var isMenuVisible : Bool
    
    var body: some View {
        ZStack {
            Button(action: {
                isMenuVisible.toggle()
            }) {
                HStack {
                    Text("Market")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Image(systemName: "arrow.down.app")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundColor(.white)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct PredictionDropdownMenu: View {
    @Binding var market : String
    @Binding var isMenuVisible : Bool
    let menuItems = ["Moneyline", "Spreads", "Totals"]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(menuItems, id: \.self) { item in
                Button(action: {
                    market = item
                    isMenuVisible = false
                }) {
                    HStack {
                        Text(item)
                            .foregroundColor(market == item ? .SportScoresRed : Color.primary)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .background(market == item ? Color(.systemGray6) : Color.white)
                
                Divider()
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.SportScoresRed, lineWidth: 2)
        )
    }
}

struct PredictionResponse: Decodable {
    var data: [PredictionData]
}

struct PredictionData: Decodable {
    var match_id: Int
    var match_dat: Int
    var league_name: String
    var country_name : String
    var home_team_name: String
    var away_team_name: String
    var rank_htw_nt: Double
    var rank_drw_nt: Double
    var rank_atw_nt: Double
}

struct PredictionHeader : View {
    var startDate : String
    var startTime : String
    @Binding var market : String
    
    var body : some View {
        Spacer()
        
        HStack {
            Text(startDate + " " + startTime)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            if(market == "Moneyline"){
                Text("Moneyline")
                    .frame(alignment: .trailing)
                    .font(.caption)
            }
            if(market == "Spreads"){
                Text("Spread")
                    .frame(alignment: .trailing)
                    .font(.caption)
            }
            if(market == "Totals"){
                Text("Over / Under")
                    .frame(alignment: .trailing)
                    .font(.caption)
            }
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
    }
}

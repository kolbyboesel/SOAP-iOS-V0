//
//  OddsStructure.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/30/23.
//

import Foundation
import SwiftUI

struct PredictionBoard : View {
    @Binding var market : String
    var data : PredictionData

    var body: some View {

        VStack {
            HStack {
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
                if(market == "Over / Unders"){
                    Text("Over / Under Pred")
                        .frame(alignment: .trailing)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            HStack {
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
                if(market == "Over / Unders"){
                    Text("Over / Under Pred")
                        .frame(alignment: .trailing)
                        .font(.caption)
                }
            }
        }
        .padding()
    }
}
struct PredictionMenuItemModel {
    var id: Int
    var sportName : String
    var APIKEY : String
    var sportID : Int
    var seasonName : String
}

struct PredictionMenuItem: View{
    var sportName: String
    var APIKEY : String
    var sportID : Int
    var seasonName : String

    var body: some View {
        NavigationLink(destination: SportPredictionView(sportName: sportName, APIKEY: APIKEY, sportID: sportID, seasonName: seasonName)) {
            HStack {
                Image(sportName + "Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 60, maxHeight: 30)
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                Text(sportName)
            }
        }
    }
}

struct PredictionMenuButton: View{
    @Binding var isMenuVisible : Bool
    @Binding var market : String
    
    var body: some View{
        HStack {
            Button(action: {
                self.isMenuVisible.toggle()
            }) {
                HStack {
                    Spacer()
                    
                    Text(market)
                        .foregroundColor(Color.primary)

                    Image(systemName: "arrow.down.circle")
                        .resizable()
                        .foregroundColor(Color.primary)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                    
                    Spacer()
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(height: 5)
                    .foregroundColor(.SportScoresRed),
                alignment: .bottom
            )
        }
    }
}

struct PredictionDropdownMenu: View {
    var menuItems: [String]
    let estimatedRowHeight: CGFloat = 44
    @Binding var market : String
    @Binding var isMenuVisible : Bool

    var body: some View {
        VStack{
            List(menuItems, id: \.self) { item in
                Button(action: {
                    market = item
                    isMenuVisible = false
                }) {
                    Text(item)
                        .foregroundColor(self.market == item ? .SportScoresRed : Color.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(.gray),
                    alignment: .bottom
                )
                .listRowInsets(EdgeInsets())
                
            }
            .frame(height: CGFloat(menuItems.count) * estimatedRowHeight)
            .listStyle(PlainListStyle())
        }
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
            if(market == "Over / Unders"){
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

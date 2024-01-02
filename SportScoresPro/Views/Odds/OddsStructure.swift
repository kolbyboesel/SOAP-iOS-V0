//
//  OddsStructure.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/30/23.
//

import Foundation
import SwiftUI

struct OddBoard : View {
    @Binding var market : String
    var data : OddsData
    var logoFetcher: LogoFetcher

    var body: some View {

        VStack {
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: 0, teamName: data.away_team) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Text(data.away_team)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if(market == "Moneyline"){
                    if(data.bookmakers[0].markets[0].outcomes[1].name == data.away_team){
                        if(data.bookmakers[0].markets[0].outcomes[1].price < 0){
                            Text("\(data.bookmakers[0].markets[0].outcomes[1].price)")
                                .frame(alignment: .trailing)
                                .font(.caption)
                        } else {
                            Text("+" + "\(data.bookmakers[0].markets[0].outcomes[1].price)")
                                .frame(alignment: .trailing)
                                .font(.caption)
                        }
                    } else {
                        if(data.bookmakers[0].markets[0].outcomes[0].price < 0){
                            Text("\(data.bookmakers[0].markets[0].outcomes[0].price)")
                                .frame(alignment: .trailing)
                                .font(.caption)
                        } else {
                            Text("+" + "\(data.bookmakers[0].markets[0].outcomes[0].price)")
                                .frame(alignment: .trailing)
                                .font(.caption)
                        }
                    }
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
            
            Spacer()
            
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: 0, teamName: data.home_team) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Text(data.home_team)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if(market == "Moneyline"){
                    if(data.bookmakers[0].markets[0].outcomes[0].name == data.home_team){
                        if(data.bookmakers[0].markets[0].outcomes[0].price < 0){
                            Text("\(data.bookmakers[0].markets[0].outcomes[0].price)")
                                .frame(alignment: .trailing)
                                .font(.caption)
                        } else {
                            Text("+" + "\(data.bookmakers[0].markets[0].outcomes[0].price)")
                                .frame(alignment: .trailing)
                                .font(.caption)
                        }
                    } else {
                        if(data.bookmakers[0].markets[0].outcomes[1].price < 0){
                            Text("\(data.bookmakers[0].markets[0].outcomes[1].price)")
                                .frame(alignment: .trailing)
                                .font(.caption)
                        } else {
                            Text("+" + "\(data.bookmakers[0].markets[0].outcomes[1].price)")
                                .frame(alignment: .trailing)
                                .font(.caption)
                        }
                    }
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
        }
        .padding()
    }
}

struct OddsMenuButton: View{
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

                    Image(systemName: "arrow.down.app")
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
                    .frame(height: 2)
                    .foregroundColor(.SportScoresRed),
                alignment: .bottom
            )
        }
    }
}

struct OddsDropdownMenu: View {
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

struct OddsResponse: Decodable {
    var data: [OddsData]
}

struct OddsData: Decodable {
    var id: String
    var commence_time: Int
    var home_team: String
    var away_team: String
    var bookmakers: [Bookmaker]
    
    struct Bookmaker: Decodable {
        var key: String
        var title: String
        var last_update: Int
        var markets: [Market]
    }
    
    struct Market: Decodable {
        var key: String
        var last_update: Int
        var outcomes: [Outcome]
    }
    
    struct Outcome: Decodable {
        var name: String
        var price: Int
    }
    
}

struct OddsHeader : View {
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

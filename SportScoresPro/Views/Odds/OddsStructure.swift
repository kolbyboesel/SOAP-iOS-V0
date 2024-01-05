//
//  OddsStructure.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/30/23.
//

import Foundation
import SwiftUI

struct OddBoard : View {
    @ObservedObject var logoFetcher: LogoFetcher
    @Binding var market : String
    var data : OddsData
    
    var body: some View {
        VStack {
            oddRow(forTeam: data, teamType: "awayTeam")
            Spacer()
            oddRow(forTeam: data, teamType: "homeTeam")
        }
        .padding()
    }
    
    @ViewBuilder
    private func oddRow(forTeam team: OddsData, teamType: String) -> some View {
        HStack {
            teamLogo(forTeam: team, teamType: teamType)
            if(teamType == "awayTeam"){
                Text(team.away_team)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(team.home_team)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if let oddText = oddText(forTeam: team, teamType: teamType) {
                Text(oddText)
                    .frame(width: 90,alignment: .center)
                    .font(.caption)
            }
        }
    }
    
    private func teamLogo(forTeam team: OddsData, teamType: String) -> some View {
        if(teamType == "awayTeam"){
            if let logo = logoFetcher.getLogo(forTeam: 0, teamName: team.away_team) {
                return Image(uiImage: logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            } else {
                return Image("placeholderLogo") // Make sure you have a placeholder image asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
        } else {
            if let logo = logoFetcher.getLogo(forTeam: 0, teamName: team.home_team) {
                return Image(uiImage: logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            } else {
                return Image("placeholderLogo") // Make sure you have a placeholder image asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    private func oddText(forTeam team: OddsData, teamType: String) -> String? {
        // Based on `market`, extract the data and format the text accordingly
        switch market {
        case "Moneyline":
            return formatMoneyline(forTeam: team, teamType: teamType)
        case "Spreads":
            return formatSpreads(forTeam: team, teamType: teamType)
        case "Totals":
            return formatOverUnder(forTeam: team, teamType: teamType)
        default:
            return nil
        }
    }
    
    private func formatMoneyline(forTeam team: OddsData, teamType: String) -> String {
        guard let marketIndex = team.bookmakers.first?.markets.firstIndex(where: { $0.key == "h2h" }),
              let outcomeIndex = team.bookmakers.first?.markets[marketIndex].outcomes.firstIndex(where: { $0.name == (teamType == "awayTeam" ? team.away_team : team.home_team) }),
              let price = team.bookmakers.first?.markets[marketIndex].outcomes[outcomeIndex].price else {
            return "N/A"
        }
        return formatPrice(price)
    }
    
    private func formatSpreads(forTeam team: OddsData, teamType: String) -> String {
        guard let marketIndex = team.bookmakers.first?.markets.firstIndex(where: { $0.key == "spreads" }),
              let outcomeIndex = team.bookmakers.first?.markets[marketIndex].outcomes.firstIndex(where: { $0.name == (teamType == "awayTeam" ? team.away_team : team.home_team) }),
              let point = team.bookmakers.first?.markets[marketIndex].outcomes[outcomeIndex].point,
              let price = team.bookmakers.first?.markets[marketIndex].outcomes[outcomeIndex].price else {
            return "N/A"
        }
        let pointString = (point > 0 ? "+" : "") + "\(point)"
        return "\(pointString)    (\(formatPrice(price)))"
    }
    
    private func formatOverUnder(forTeam team: OddsData, teamType: String) -> String {
        guard let marketIndex = team.bookmakers.first?.markets.firstIndex(where: { $0.key == "totals" }),
              let overOutcome = team.bookmakers.first?.markets[marketIndex].outcomes.first(where: { $0.name == "Over" }),
              let point = overOutcome.point else {
            return "N/A"
        }
        
        let pointString = "\(point)"
        let priceString = formatPrice(overOutcome.price)
        
        return "\(pointString)" + "    (\(priceString))"
    }
    
    private func formatPrice(_ price: Int) -> String {
        return price < 0 ? "\(price)" : "+\(price)"
    }
}

struct OddsMenuButton: View{
    @Binding var market : String
    @Binding var isMenuVisible : Bool
    
    var body: some View {
        ZStack {
            Button(action: {
                isMenuVisible.toggle()
            }) {
                if(isMenuVisible){
                    HStack {
                        Text("\(market)")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        
                        Image(systemName: "arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 18)
                            .foregroundColor(.white)
                        
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                } else {
                    HStack {
                        Text("\(market)")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                        
                        Image(systemName: "arrow.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 18)
                            .foregroundColor(.white)
                        
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct OddsDropdownMenu: View {
    @Binding var market : String
    @Binding var isMenuVisible : Bool
    let menuItems = ["Moneyline", "Spreads", "Totals"]
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Spacer()
                
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
                                    .frame(maxWidth: geometry.size.width * 0.4)
                            }
                            .padding(.horizontal)
                        }
                        .background(market == item ? Color(.systemGray6) : Color(.systemBackground))
                        
                        Divider()
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.4)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.SportScoresRed, lineWidth: 2)
                )
            }
            .padding()
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
        var point: Double?
    }
}

struct OddsHeader : View {
    @Binding var market : String
    var startDate : String
    var startTime : String
    
    var body : some View {
        Spacer()
        
        HStack {
            Text(startDate + " " + startTime)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            if(market == "Moneyline"){
                Text("Moneyline")
                    .frame(width: 90,alignment: .center)
                    .font(.caption)
            }
            if(market == "Spreads"){
                Text("Spread  (Line)")
                    .font(.caption)
                    .frame(width: 90,alignment: .center)
            }
            if(market == "Totals"){
                Text("O/U    (Line)")
                    .font(.caption)
                    .frame(width: 90,alignment: .center)
            }
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
    }
}

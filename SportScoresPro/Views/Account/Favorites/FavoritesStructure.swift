//
//  FavoritesStructure.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct SportFavoriteView: View {
    var ScoreKey: String
    var sportID: Int
    @ObservedObject var logoFetcher : LogoFetcher

    @State private var liveScoreData: [LiveScoreData] = []
    @State private var selectedDate = Date()
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0){
            if isLoading {
                ProgressView("Loading...")
            } else {
                VStack(spacing: 0) {
                    List {
                        ForEach(liveScoreData.indices, id: \.self) { index in
                            
                            let data = liveScoreData[index]
                            
                            let formattedDate = formatEventDate(epochTIS: data.startTimestamp)
                            let formattedTime = formatEventTime(epochTIS: data.startTimestamp)
                            let selectedFormattedDate = formatVerifyDate(date: selectedDate)
                            let verifyDate = formattedDate == selectedFormattedDate
                            
                            if verifyDate == true {
                                VStack {
                                    FavoritesScoreHeader(data: data, formattedDate: formattedDate, formattedTime: formattedTime, sportID: sportID)
                                    Spacer(minLength: 20)
                                    if data.status.description == "Not started"{
                                        FavoriteScoreFuture(logoFetcher: logoFetcher, data: data)
                                    } else {
                                        FavoriteScoreLive(logoFetcher: logoFetcher, data: data)
                                    }
                                    if index != liveScoreData.count - 1 {
                                        SportDivider(color: .secondary, width: 2)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listSectionSeparator(.hidden)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .contentMargins(.top, 20)
                    .contentMargins(.bottom, 20)
                }
            }
        }
        .onAppear {
            isLoading = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDate = dateFormatter.string(from: Date())
            
            getScoresData(forSport: ScoreKey, forSport: sportID, selectedDate: todayDate) { fetchedData in
                self.liveScoreData = fetchedData
                isLoading = false
                
            }
        }
        .onDisappear {
        }
    }
}
struct FavoriteScoreFuture: View {
    @ObservedObject var logoFetcher : LogoFetcher
    var data : LiveScoreData
    
    var body: some View {
        let awayKey = TeamKey(teamID: data.awayTeam.id, teamName: data.awayTeam.name)
        let homeKey = TeamKey(teamID: data.homeTeam.id, teamName: data.homeTeam.name)
        
        HStack{
            VStack {
                HStack {
                    if let logo = logoFetcher.teamLogos[awayKey] {
                        Image(uiImage: logo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    } else {
                        ProgressView()
                            .onAppear {
                                logoFetcher.fetchLogo(forTeam: data.awayTeam.id, teamName: data.awayTeam.name)
                            }
                            .frame(width: 30, height: 30)
                    }
                    
                    Text(data.awayTeam.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                Spacer()
                
                HStack {
                    if let logo = logoFetcher.teamLogos[homeKey] {
                        Image(uiImage: logo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    } else {
                        ProgressView()
                            .onAppear {
                                logoFetcher.fetchLogo(forTeam: data.homeTeam.id, teamName: data.homeTeam.name)
                            }
                            .frame(width: 30, height: 30)
                    }
                    
                    Text(data.homeTeam.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
        }
    }
}

struct FavoriteScoreLive: View {
    @ObservedObject var logoFetcher : LogoFetcher
    var data : LiveScoreData
    
    var body: some View {
        let awayKey = TeamKey(teamID: data.awayTeam.id, teamName: data.awayTeam.name)
        let homeKey = TeamKey(teamID: data.homeTeam.id, teamName: data.homeTeam.name)
        VStack {
            HStack {
                if let logo = logoFetcher.teamLogos[awayKey] {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                } else {
                    ProgressView()
                        .onAppear {
                            logoFetcher.fetchLogo(forTeam: data.awayTeam.id, teamName: data.awayTeam.name)
                        }
                        .frame(width: 30, height: 30)
                }
                
                Text(data.awayTeam.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let score = data.awayScore?.current {
                    Text("\(score)")
                        .frame(alignment: .trailing)
                } else {
                    Text("")
                }
            }
            
            Spacer()
            
            HStack {
                if let logo = logoFetcher.teamLogos[homeKey] {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                } else {
                    ProgressView()
                        .onAppear {
                            logoFetcher.fetchLogo(forTeam: data.homeTeam.id, teamName: data.awayTeam.name)
                        }
                        .frame(width: 30, height: 30)
                }
                
                Text(data.homeTeam.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let score = data.homeScore?.current {
                    Text("\(score)")
                        .frame(alignment: .trailing)
                } else {
                    Text("")
                }
            }
        }
    }
}

struct FavoritesScoreHeader : View {
    var data : LiveScoreData
    var formattedDate : String
    var formattedTime : String
    var sportID : Int
    
    var body : some View {
        Spacer()
        
        HStack {
            Text(formattedDate + " " + formattedTime)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            
            if(data.status.type == "inprogress" && sportID != 1){
                let plength = data.time?.periodLength ?? 0
                let tperiod = data.time?.totalPeriodCount ?? 1
                let played = data.time?.played ?? 0

                let currentMinute = String((plength - (played / tperiod)) / 60)
                let currentSecond = ((plength - (played / tperiod)) % 60)
                let description = data.status.description
                if let rangePeriod = currentMinute.range(of: ".") {
                    let updatedCurMin = description[..<rangePeriod.lowerBound]
                    
                    if let rangeDecription = description.range(of: " ") {
                        let currentPeriod = description[..<rangeDecription.lowerBound]
                        Text(currentPeriod + " " + updatedCurMin + ":\(currentSecond)")
                            .frame(alignment: .trailing)
                            .font(.caption)
                    }
                } else {
                    if let rangeDecription = description.range(of: " ") {
                        let currentPeriod = description[..<rangeDecription.lowerBound]
                        
                        Text(currentPeriod + " " + currentMinute + ":\(currentSecond)")
                            .frame(alignment: .trailing)
                            .font(.caption)
                    }
                }
            } else {
                Text(data.status.description)
                    .frame(alignment: .trailing)
                    .font(.caption)
            }
        }
    }
}



struct FavoriteOddsView: View {
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
                    ForEach(oddsData.indices, id: \.self) { index in
                        let data = oddsData[index]

                        let startTime = formatEventTime(epochTIS: TimeInterval(data.commence_time))
                        let startDate = formatEventDate(epochTIS: TimeInterval(data.commence_time))
                        VStack {
                            FavoriteOddsHeader(market: $market, startDate: startDate, startTime: startTime)
                            Spacer(minLength: 20)

                            FavoriteOddBoard(logoFetcher: logoFetcher, market: $market, data: data)
                            
                            if index != oddsData.count - 1 {
                                SportDivider(color: .secondary, width: 2)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                }
                .listStyle(.plain)
                .contentMargins(.top, 20)
                .contentMargins(.bottom, 20)
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

struct FavoriteOddBoard : View {
    @ObservedObject var logoFetcher: LogoFetcher
    @Binding var market : String
    var data : OddsData
    
    var body: some View {
        VStack {
            oddRow(forTeam: data, teamType: "awayTeam")
            Spacer()
            oddRow(forTeam: data, teamType: "homeTeam")
        }
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

struct FavoriteOddsHeader : View {
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
    }
}

struct FavoritePredictionView: View {
    var PredictionKey : String
    var sportID: Int
    var seasonName : String
    @Binding var market : String
    @ObservedObject var logoFetcher: LogoFetcher
    @EnvironmentObject var settings: UserSettings

    @State private var predictionData: [PredictionData] = []
    var usablePredData: [PredictionData] = []
    @State private var isLoading = false
    

    var body: some View {
        VStack(){
            if isLoading {
                ProgressView("Loading...")
            } else {
                if settings.loggedIn {
                    List{
                        let filteredData = filteredPredictionData(for: predictionData, seasonName: seasonName, selectedDate: Date())
                        
                        ForEach(filteredData.indices, id: \.self) { index in
                            
                            let data = filteredData[index]
                            
                            let startTime = formatEventTime(epochTIS: TimeInterval(data.match_dat))
                            let startDate = formatEventDate(epochTIS: TimeInterval(data.match_dat))
                            
                            VStack {
                                FavoritePredictionHeader(startDate: startDate, startTime: startTime)
                                
                                Spacer(minLength: 20)

                            
                                FavoritePredictionBoard(logoFetcher: logoFetcher, data: data, sportID: sportID)
                                
                                if index != filteredData.count - 1 {
                                    SportDivider(color: .secondary, width: 2)
                                }
                            }
                            
                        }
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .contentMargins(.top, 20)
                    .contentMargins(.bottom, 20)
                } else {
                    
                    Text("Please log in or create an account to access all predictions")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color.SportScoresRed)
                        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    
                    if let firstPrediction = predictionData.first {
                        let startTime = formatEventTime(epochTIS: TimeInterval(firstPrediction.match_dat))
                        let startDate = formatEventDate(epochTIS: TimeInterval(firstPrediction.match_dat))
                        let selectedFormattedDate = formatVerifyDate(date: Date())
                        let verifyDate = startDate == selectedFormattedDate
                        if(firstPrediction.league_name == seasonName && verifyDate){
                            List {
                                VStack {
                                    PredictionHeader(startDate: startDate, startTime: startTime)
                                    
                                    PredictionBoard(logoFetcher: logoFetcher, data: firstPrediction, sportID: sportID)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        .onAppear {
            isLoading = true
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDate = dateFormatter.string(from: Date())
            
            let currentDate = Date()
            var nextDateString = " "
            if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                nextDateString = dateFormatter.string(from: nextDate)
            } else {
                print("Could not calculate the next date.")
            }
            
            getPredictionData(forSport: PredictionKey, forSport: sportID, selectedDate: todayDate, seasonName: seasonName) { fetchedData in
                self.predictionData = fetchedData
                getPredictionData(forSport: PredictionKey, forSport: sportID, selectedDate: nextDateString, seasonName: seasonName) { nextDayData in
                    self.predictionData.append(contentsOf: nextDayData)
                    self.isLoading = false
                }
            }
        }
    }
}

struct FavoritePredictionBoard : View {
    @ObservedObject var logoFetcher : LogoFetcher
    var data : PredictionData
    var sportID: Int
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: 0, teamName: data.away_team_name) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Text(data.away_team_name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(Int(data.rank_atw_nt * 100))%")
                    .frame(alignment: .trailing)
                    .font(.caption)
            }
            
            Spacer(minLength: 20)
            
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: 0, teamName: data.home_team_name) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Text(data.home_team_name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(Int(data.rank_htw_nt * 100))%")
                    .frame(alignment: .trailing)
                    .font(.caption)
            }
            
            Spacer()
            Divider()
            
            Text("Over Predictions")
                .padding()
                .frame(width: .infinity, alignment: .center)
                .foregroundColor(Color.primary)
                .font(.system(size: 15))
                        
            Divider()
            Spacer()
            
            OverHeader(sportID: sportID)
                .frame(height: 30)
                        
            Divider()
            
            OverPred(sportID: sportID, predictionData: data)
                .frame(height: 30)
        }
        .padding()
    }
}

struct FavoritePredictionHeader : View {
    var startDate : String
    var startTime : String
    
    var body : some View {
        Spacer()
        
        HStack {
            Text(startDate + " " + startTime)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            Text("Moneyline")
                .frame(alignment: .trailing)
                .font(.caption)
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
    }
}

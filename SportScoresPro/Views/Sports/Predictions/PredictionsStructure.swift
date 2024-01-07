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

struct PredictionMenuButton: View{
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
    // Baseball Overs
    var rank_to_65_nt : Double?
    var rank_to_75_nt : Double?
    var rank_to_85_nt : Double?
    var rank_to_95_nt : Double?
    var rank_to_105_nt : Double?
    // Hockey Overs (Also uses rank_to_65_nt and rank_to_75_nt)
    var rank_to_35_nt : Double?
    var rank_to_45_nt : Double?
    var rank_to_55_nt : Double?
    // Basketball Overs (197.5, 205.5, 213.5, 221.5, 229.5
    var rank_to_lvl1_nt : Double?
    var rank_to_lvl2_nt : Double?
    var rank_to_lvl3_nt : Double?
    var rank_to_lvl4_nt : Double?
    var rank_to_lvl5_nt : Double?
}

struct PredictionHeader : View {
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

struct OverHeader: View {
    var sportID: Int
    var lvl1: Double
    var lvl2: Double
    var lvl3: Double
    var lvl4: Double
    var lvl5: Double
    
    init(sportID: Int) {
        self.sportID = sportID
        
        switch sportID {
        case 2:
            (lvl1, lvl2, lvl3, lvl4, lvl5) = (197.5, 205.5, 213.5, 221.5, 229.5)
        case 4:
            (lvl1, lvl2, lvl3, lvl4, lvl5) = (3.5, 4.5, 5.5, 6.5, 7.5)
        case 64:
            (lvl1, lvl2, lvl3, lvl4, lvl5) = (6.5, 7.5, 8.5, 9.5, 10.5)
        default:
            (lvl1, lvl2, lvl3, lvl4, lvl5) = (0.0, 0.0, 0.0, 0.0, 0.0)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Text(roundToOneDecimalPlaceAsString(lvl1))
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
                
                Divider()
                
                Text(roundToOneDecimalPlaceAsString(lvl2))
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
                
                Divider()
                
                Text(roundToOneDecimalPlaceAsString(lvl3))
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
                
                Divider()
                
                Text(roundToOneDecimalPlaceAsString(lvl4))
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
                
                Divider()
                
                Text(roundToOneDecimalPlaceAsString(lvl5))
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
            }
            .frame(width: geometry.size.width)
        }
    }
}

struct OverPred: View {
    var sportID: Int
    var predictionData : PredictionData
    var lvl1: Double
    var lvl2: Double
    var lvl3: Double
    var lvl4: Double
    var lvl5: Double
    
    init(sportID: Int, predictionData : PredictionData) {
        self.sportID = sportID
        self.predictionData = predictionData

        switch sportID {
        case 2:
            (lvl1, lvl2, lvl3, lvl4, lvl5) = (predictionData.rank_to_lvl1_nt ?? 0.0, predictionData.rank_to_lvl2_nt ?? 0.0, predictionData.rank_to_lvl3_nt ?? 0.0, predictionData.rank_to_lvl4_nt ?? 0.0, predictionData.rank_to_lvl5_nt ?? 0.0)
        case 4:
            (lvl1, lvl2, lvl3, lvl4, lvl5) = (predictionData.rank_to_35_nt ?? 0.0, predictionData.rank_to_45_nt ?? 0.0, predictionData.rank_to_55_nt ?? 0.0, predictionData.rank_to_65_nt ?? 0.0, predictionData.rank_to_75_nt ?? 0.0)
        case 64:
            (lvl1, lvl2, lvl3, lvl4, lvl5) = (predictionData.rank_to_65_nt ?? 0.0, predictionData.rank_to_75_nt ?? 0.0, predictionData.rank_to_85_nt ?? 0.0, predictionData.rank_to_95_nt ?? 0.0, predictionData.rank_to_105_nt ?? 0.0)
        default:
            (lvl1, lvl2, lvl3, lvl4, lvl5) = (0.0, 0.0, 0.0, 0.0, 0.0)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Text(roundToOneDecimalPlaceAsString(lvl1 * 100) + "%")
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)

                Divider()

                Text(roundToOneDecimalPlaceAsString(lvl2 * 100) + "%")
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)

                Divider()

                Text(roundToOneDecimalPlaceAsString(lvl3 * 100) + "%")
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)

                Divider()

                Text(roundToOneDecimalPlaceAsString(lvl4 * 100) + "%")
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)

                Divider()

                Text(roundToOneDecimalPlaceAsString(lvl5 * 100) + "%")
                    .frame(width: geometry.size.width / 5, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
            }
            .frame(width: geometry.size.width)
        }
    }
}

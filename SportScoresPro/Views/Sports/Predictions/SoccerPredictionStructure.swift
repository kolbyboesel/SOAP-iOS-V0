//
//  SoccerPredictionStructure.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct SoccerPredictionBoard : View {
    @ObservedObject var logoFetcher : LogoFetcher
    var data : SoccerPredictionData
    var sportID: Int
    
    var body: some View {
        
        VStack(spacing: 0) {
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: 0, teamName: data.awayTeam) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Text(data.awayTeam)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(data.away_win + "%")
                    .frame(alignment: .trailing)
                    .font(.caption)
            }
            
            Spacer(minLength: 20)
            
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: 0, teamName: data.homeTeam) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Text(data.homeTeam)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(data.home_win + "%")
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
            
            SoccerOverHeader()
                .frame(height: 30)
                        
            Divider()
            
            SoccerOverPred(predictionData: data)
                .frame(height: 30)
        }
        .padding()
    }
}

struct SoccerPredictionHeader : View {
    var startDate : String
    
    var body : some View {
        Spacer()
        
        HStack {
            Text(startDate)
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

struct SoccerOverHeader: View {
    var lvl1 = 1.5
    var lvl2 = 2.5
    var lvl3 = 3.5
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Text(roundToOneDecimalPlaceAsString(lvl1))
                    .frame(width: geometry.size.width / 3, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
                
                Divider()
                
                Text(roundToOneDecimalPlaceAsString(lvl2))
                    .frame(width: geometry.size.width / 3, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
                
                Divider()
                
                Text(roundToOneDecimalPlaceAsString(lvl3))
                    .frame(width: geometry.size.width / 3, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
            }
            .frame(width: geometry.size.width)
        }
    }
}

struct SoccerOverPred: View {
    var predictionData : SoccerPredictionData
    
    var body: some View {
        let lvl1 = predictionData.over15goals
        let lvl2 = predictionData.over25goals
        let lvl3 = predictionData.over35goals
        
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Text(lvl1 + "%")
                    .frame(width: geometry.size.width / 3, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)

                Divider()

                Text(lvl2 + "%")
                    .frame(width: geometry.size.width / 3, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)

                Divider()

                Text(lvl3 + "%")
                    .frame(width: geometry.size.width / 3, alignment: .center)
                    .foregroundColor(Color.primary)
                    .font(.caption)
            }
            .frame(width: geometry.size.width)
        }
    }
}


struct SoccerPredictionResponse: Decodable {
    var data: [SoccerPredictionData]
}

struct SoccerPredictionData: Decodable {
    var id: Int
    var date: String
    var awayTeam: String
    var homeTeam: String
    var competition: String
    var country : String
    var home_win: String
    var away_win: String
    var draw: String
    var both_teams_to_score: String
    var over15goals: String
    var over25goals : String
    var over35goals : String
    var correctscore : String
    var homeform : String
    var awayform : String
}

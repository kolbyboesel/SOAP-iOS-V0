//
//  ScoresStructure.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/30/23.
//

import Foundation
import SwiftUI

struct ScoreFuture: View {
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
            .padding()
        }
    }
}

struct ScoreLive: View {
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
        .padding()
    }
}

struct ScoresHeader : View {
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
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
    }
}

struct LiveScoreResponse: Decodable {
    var data: [LiveScoreData]
}

struct LiveScoreData: Decodable, Identifiable {
    var id: Int
    var startTimestamp: TimeInterval
    var homeTeam: Team
    var awayTeam: Team
    var homeScore: Score?
    var awayScore: Score?
    var tournament: Tournament?
    var season: Season?
    var status: Status
    var time: Time?

    
    struct Team: Decodable {
        var id: Int
        var name: String
        var nameCode: String
        var shortName: String
    }
    
    struct Score: Decodable {
        var current: Int?
    }
    
    struct Tournament: Decodable {
        var name: String?
        var category: Category?
        var uniqueTournament: UniqueTournament?
    }
    
    struct Season: Decodable {
        var name: String?
    }
    
    struct Status: Decodable {
        var description: String
        var type: String
    }
    
    struct Time: Decodable {
        var played: Int?
        var periodLength: Int?
        var totalPeriodCount: Int?
    }
    
    struct Category: Decodable {
        var name: String?
    }
    
    struct UniqueTournament: Decodable {
        var name: String?
    }
}

//
//  ScoresStructure.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/30/23.
//

import Foundation
import SwiftUI

struct ScoreFuture: View {
    var data : LiveScoreData
    var logoFetcher : LogoFetcher

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
    var data : LiveScoreData
    var logoFetcher : LogoFetcher

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
    
    var body : some View {
        Spacer()
        
        HStack {
            Text(formattedDate + " " + formattedTime)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            
            
            Text(data.status.description)
                .frame(alignment: .trailing)
                .font(.caption)
            
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
    }
    
    struct Season: Decodable {
        var name: String?
    }
    
    struct Status: Decodable {
        var description: String
    }
}

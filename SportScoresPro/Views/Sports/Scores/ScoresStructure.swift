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
        
        HStack{
            VStack {
                HStack {
                    if let logo = logoFetcher.getLogo(forTeam: data.awayTeam.id, teamName: data.awayTeam.name) {
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
                    if let logo = logoFetcher.getLogo(forTeam: data.homeTeam.id, teamName: data.homeTeam.name) {
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
        
        let awayScore = data.awayScore?.current ?? 0
        let homeScore = data.homeScore?.current ?? 0

        VStack {
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: data.awayTeam.id, teamName: data.awayTeam.name) {
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
                
                if(awayScore > homeScore){
                    Text(data.awayTeam.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    if let score = data.awayScore?.current {
                        Text("\(score)")
                            .frame(alignment: .trailing)
                            .bold()
                    } else {
                        Text("")
                    }
                } else {
                    Text(data.awayTeam.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let score = data.awayScore?.current {
                        Text("\(score)")
                            .frame(alignment: .trailing)
                    } else {
                        Text("")
                    }
                }
            }
            
            Spacer()
            
            HStack {
                if let logo = logoFetcher.getLogo(forTeam: data.homeTeam.id, teamName: data.homeTeam.name) {
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
                
                if(awayScore < homeScore){
                    Text(data.homeTeam.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    if let score = data.homeScore?.current {
                        Text("\(score)")
                            .frame(alignment: .trailing)
                            .bold()
                    } else {
                        Text("")
                    }
                } else {
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
                        Text(currentPeriod + " " + updatedCurMin + ":" + "\(currentSecond)")
                            .frame(alignment: .trailing)
                            .font(.caption)
                    }
                } else {
                    if let rangeDecription = description.range(of: " ") {
                        let currentPeriod = description[..<rangeDecription.lowerBound]
                        
                        Text(currentPeriod + " " + currentMinute + ":" + "\(currentSecond)")
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

struct CollegeFilterMenuButton: View{
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
        }
    }
}

struct CollegeFilterDropdownMenu: View {
    @Binding var market : String
    @Binding var isMenuVisible : Bool
    let menuItems = ["All", "Big 10", "SEC", ""]
    
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
                .shadow(radius: 5)
            }
            .padding()
        }
    }
}

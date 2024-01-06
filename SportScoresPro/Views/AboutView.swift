//
//  AboutView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/29/23.
//

import Foundation
import SwiftUI

struct AboutView: View {
    @EnvironmentObject var settings: UserSettings
    
    @State var notificationToggle: Bool = false
    @State var locationUsage: Bool = false

    var body: some View {
        let aboutDataArray: [AboutModel] = [
            AboutModel(id: 1, image: "1", titleText: "About", descriptionText: "Thank you for visiting Sport Scores Pro! This app is your hub for sport scores, betting odds, and more! Currently available are scores and moneyline odds for, NFL, NBA, MLB, NHL, College Football, College Basketball, College Baseball, Europe’s 5 Main Soccer Leagues (Premier League, Serie A, Bundesliga, LaLiga, and Ligue 1), and the MLS"),
            AboutModel(id: 2, image: "2", titleText: "Account Benefits", descriptionText: "Now when creating a Sport Scores Pro account you get access to soccer betting predictions for Europe's top 5 leagues, as well as the MLS. These predictions are based on a variety of data, and are intended to give you +EV bets."),
            AboutModel(id: 3, image: "3", titleText: "New Feature", descriptionText: "In the latest update, we've added a search by date function! Select a date in the scores tab for any league, and you will see a list of events from that day.")
        ]
        VStack(spacing: 0) {
            
            GeometryReader { geometry in
                ScrollView {
                    ForEach(aboutDataArray, id: \.id) { item in
                        AboutModelView(aboutData: item)
                            .frame(maxHeight: geometry.size.height)
                    }
                }
                .background(Color(.systemGray6))
                .frame(maxWidth: geometry.size.width)
                .frame(maxHeight: .infinity)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image("home-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                        }
                    }
                }
            }
        }
    }
}
    

struct AboutModel {
    var id: Int
    var image: String
    var titleText: String
    var descriptionText: String
    var showButton: Bool?
}

struct AboutModelView: View {
    var aboutData: AboutModel
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        VStack(spacing: 20) {
            Text(aboutData.titleText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.primary)
                .multilineTextAlignment(.center)
            
            Image(aboutData.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            Text(aboutData.descriptionText)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.secondary)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding()
    }
}

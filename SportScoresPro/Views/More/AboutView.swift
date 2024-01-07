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
            AboutModel(id: 1, image: "2", titleText: "Account Benefits", descriptionText: "Why create an account with Sport Scores Pro? Creating an account gives you access to high quality betting picks intended to give you +EV bets. Expected value (EV) in sports betting is a way to measure the probability gap between a bettor’s expectations and the sportsbook’s. So using a variety of data, you're given picks for every game from the supported leagues which give you the best opportunities to win. An example pick can be seen on the left, and includes the odds of a given team to win, as well as over predictions for given values. Currently supported are MLB, NFL, NHL, and NBA, and the rest of the sports listed above will be available during the season."),
            AboutModel(id: 2, image: "1", titleText: "About", descriptionText: "Currently available are scores, betting odds, and +EV betting predictions for all sports in the image above (Football betting predictions not currently available)"),
            AboutModel(id: 3, image: "3", titleText: "Favorites", descriptionText: "Now available is the ability to choose your favorite sports! Clicking the account icon on the home screen will allow you to choose your favorite sports, which will then appear on the home screen each time you launch the app"),
            AboutModel(id: 4, image: "4", titleText: "Search By Date", descriptionText: "We've added a search by date function! Select a date in the scores tab for any league, and you will see a list of events from that day.")
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
                .navigationTitle("About")
                .navigationBarTitleDisplayMode(.large)
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

//
//  LiveTabBar.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 1/6/24.
//

import Foundation
import SwiftUI

struct LiveTabBar: View {
    @ObservedObject var logoFetcher : LogoFetcher
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(){
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        
                        Button(action: { selectedTab = 0 }) {
                            VStack {
                                VStack {
                                    Text("Football")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .fontWeight(selectedTab == 0 ? .bold : .regular)
                                    
                                }
                                if selectedTab == 0 {
                                    Color.white.frame(height: 3)
                                } else {
                                    Color.clear.frame(height: 0)
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                        
                        Button(action: {
                            selectedTab = 1
                        }) {
                            VStack {
                                VStack {
                                    Text("Basketball")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .fontWeight(selectedTab == 1 ? .bold : .regular)
                                    
                                }
                                if selectedTab == 1 {
                                    Color.white.frame(height: 3)
                                } else {
                                    Color.clear.frame(height: 0)
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                        
                        Button(action: {
                            selectedTab = 2
                        }) {
                            VStack {
                                VStack {
                                    Text("Baseball")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .fontWeight(selectedTab == 2 ? .bold : .regular)
                                    
                                }
                                if selectedTab == 2 {
                                    Color.white.frame(height: 3)
                                } else {
                                    Color.clear.frame(height: 0)
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                        
                        Button(action: {
                            selectedTab = 3
                        }) {
                            VStack {
                                VStack {
                                    Text("Hockey")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .fontWeight(selectedTab == 3 ? .bold : .regular)
                                    
                                }
                                if selectedTab == 3 {
                                    Color.white.frame(height: 3)
                                } else {
                                    Color.clear.frame(height: 0)
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                        
                        Button(action: {
                            selectedTab = 4
                        }) {
                            VStack {
                                VStack {
                                    Text("Soccer")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .fontWeight(selectedTab == 4 ? .bold : .regular)
                                    
                                }
                                if selectedTab == 4 {
                                    Color.white.frame(height: 3)
                                } else {
                                    Color.clear.frame(height: 0)
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                    }
                }
                .background(Color.SportScoresRed)
                
                Group {
                    switch selectedTab {
                    case 0:
                        NavigationView{
                            LiveScoresView(sportID: 63, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Football Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 1:
                        NavigationView{
                            LiveScoresView(sportID: 2, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Basketball Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 2:
                        NavigationView{
                            LiveScoresView(sportID: 64, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Baseball Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 3:
                        NavigationView{
                            LiveScoresView(sportID: 4, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Hockey Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 4:
                        NavigationView{
                            LiveScoresView(sportID: 1, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Soccer Live")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    default:
                        NavigationView{
                            LiveScoresView(sportID: 63, logoFetcher: logoFetcher)
                        }
                        .navigationTitle("Football Live")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .zIndex(0)
            }
        }
    }
}

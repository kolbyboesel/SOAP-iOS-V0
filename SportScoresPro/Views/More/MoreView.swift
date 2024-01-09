//
//  AccountView.swift
//  SportScoresPro
//
//  Created by Kolby Boesel on 12/23/23.
//

import SwiftUI
import Auth0
import JWTDecode


struct MoreView: View {
    @ObservedObject var logoFetcher: LogoFetcher
    @EnvironmentObject var userSettings: UserSettings
    @State var user: UserAuth?
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                List {
                    if userSettings.loggedIn {
                        Section {
                            NavigationLink(destination: AccountView(logoFetcher: logoFetcher).environmentObject(userSettings)) {
                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .padding(.top, 5)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                        .foregroundColor(Color.primary)
                                    
                                    Text("Account")
                                        .foregroundColor(Color.primary)
                                    
                                }
                                
                            }
                        }
                    } else {
                        Section {
                            NavigationLink(destination: SignupView(logoFetcher: logoFetcher).environmentObject(userSettings)) {
                                HStack {
                                    Image(systemName: "person.crop.circle.fill.badge.plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .padding(.top, 5)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                        .foregroundColor(Color.primary)
                                    
                                    Text("Sign Up")
                                        .foregroundColor(Color.primary)
                                    
                                }
                            }
                            NavigationLink(destination: LogInView(logoFetcher: logoFetcher).environmentObject(userSettings)) {
                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .padding(.top, 5)
                                        .padding(.trailing, 15)
                                        .padding(.bottom, 5)
                                        .foregroundColor(Color.primary)
                                    
                                    Text("Log In")
                                        .foregroundColor(Color.primary)
                                    
                                }
                            }
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: AboutView().accentColor(.white)) {
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .padding(.top, 5)
                                .padding(.trailing, 15)
                                .padding(.bottom, 5)
                                .foregroundColor(Color.primary)
                            
                            Text("About")
                        }
                    }
                    
                    Section {
                        Text("**While in development, all predictions and account functions will be free for all users**")
                            .font(.body)
                            .bold()
                            .padding()
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.primary)
                    }
                    
                }
                .contentMargins(.top, 20)
                .navigationTitle("More")
            }
        }
        .accentColor(.white)
    }
}

struct UserAuth {
    let id: String
    let name: String
    let email: String
    let emailVerified: String
    let picture: String
    let updatedAt: String
}

extension UserAuth {
    init?(from idToken: String) {
        guard let jwt = try? decode(jwt: idToken),
              let id = jwt.subject,
              let name = jwt["name"].string,
              let email = jwt["email"].string,
              let emailVerified = jwt["email_verified"].boolean,
              let picture = jwt["picture"].string,
              let updatedAt = jwt["updated_at"].string else {
            return nil
        }
        self.id = id
        self.name = name
        self.email = email
        self.emailVerified = String(describing: emailVerified)
        self.picture = picture
        self.updatedAt = updatedAt
    }
}

struct HeroView: View {
    private let tracking: CGFloat = -4

    var body: some View {
    #if os(iOS)
        Image("Auth0")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 28, alignment: .center)
            .padding(.top, 8)
        VStack(alignment: .leading, spacing: -32) {
            Text("Swift")
                .tracking(self.tracking)
                .foregroundStyle(
                    .linearGradient(
                      colors: [Color("Orange"), Color("Pink")],
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                    ))
            Text("Sample")
                .tracking(self.tracking)
            Text("App")
                .tracking(self.tracking)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.custom("SpaceGrotesk-Medium", size: 80))
    #else
        Text("Swift Sample App")
            .font(.title)
    #endif
    }
}

struct ProfileHeader: View {
    @State var picture: String

    private let size: CGFloat = 100

    var body: some View {
    #if os(iOS)
        AsyncImage(url: URL(string: picture), content: { image in
            image.resizable()
        }, placeholder: {
            Color.clear
        })
        .frame(width: self.size, height: self.size)
        .clipShape(Circle())
        .padding(.bottom, 24)
    #else
        Text("Profile")
    #endif
    }
}

struct ProfileCell: View {
    @State var key: String
    @State var value: String

    private let size: CGFloat = 14

    var body: some View {
        HStack {
            Text(key)
                .font(.system(size: self.size, weight: .semibold))
            Spacer()
            Text(value)
                .font(.system(size: self.size, weight: .regular))
            #if os(iOS)
                .foregroundColor(Color("Grey"))
            #endif
        }
    #if os(iOS)
        .listRowBackground(Color.white)
    #endif
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    private let padding: CGFloat = 8

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .padding(.init(top: self.padding,
                           leading: self.padding * 6,
                           bottom: self.padding,
                           trailing: self.padding * 6))
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


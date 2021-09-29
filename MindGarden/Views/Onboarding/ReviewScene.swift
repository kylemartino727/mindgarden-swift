//
//  ReviewScene.swift
//  MindGarden
//
//  Created by Mark Jones on 12/6/21.
//

import SwiftUI

var tappedTurnOn = false
struct ReviewScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var experience: (Image, String) =  (Img.moon, "")
    @State private var aim = (Img.redTulips3, "")
    @State private var notifications = ""
    var displayedTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }

    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(spacing: -10) {
                        HStack {
                            Img.topBranch.padding(.leading, -20)
                            Spacer()
                        }
                        Text("So, to recap \(UserDefaults.standard.string( forKey: "name") ?? "")")
                            .font(Font.mada(.bold, size: 30))
                            .foregroundColor(Clr.black2)
                            .padding()
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * 0.22)
                                .neoShadow()
                            HStack(spacing: -10){
                                aim.0
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.2, height: width * 0.2)
                                    .padding()
                                VStack(alignment: .leading) {
                                    Text("Your aim is to")
                                        .foregroundColor(.gray)
                                        .font(Font.mada(.regular, size: 20))
                                    Text("\(aim.1)")
                                        .foregroundColor(Clr.black1)
                                        .font(Font.mada(.semiBold, size: 22))
                                }.frame(width: width * 0.5, alignment: .leading)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * 0.22)
                                .neoShadow()
                            HStack(spacing: -10) {
                                experience.0
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.2, height: width * 0.2)
                                    .padding()
                                VStack(alignment: .leading) {
                                    Text("Your experience level")
                                        .foregroundColor(.gray)
                                        .font(Font.mada(.regular, size: 20))
                                    Text("\(experience.1)")
                                        .foregroundColor(Clr.black1)
                                        .font(Font.mada(.semiBold, size: 22))
                                }.frame(width: width * 0.5, alignment: .leading)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .cornerRadius(14)
                                .frame(width: width * 0.75, height: width * 0.22)
                                .neoShadow()
                            HStack(spacing: -10){
                                Img.bell
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * 0.15, height: width * 0.2)
                                    .padding()
                                    .padding(.trailing)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Your notifcations are")
                                        .foregroundColor(.gray)
                                        .font(Font.mada(.regular, size: 20))
                                    HStack {
                                        Text("\(notifications)")
                                            .foregroundColor(Clr.black1)
                                            .font(Font.mada(.semiBold, size: 22))
                                        if notifications == "Off" {
                                            Button {
                                                withAnimation {
                                                    tappedTurnOn = true
                                                    viewRouter.currentPage = .notification
                                                }
                                            } label: {
                                                Capsule()
                                                    .fill(Clr.yellow)
                                                    .frame(width: width * 0.2, height: height * 0.03)
                                                    .neoShadow()
                                                    .overlay(
                                                        Text("Turn On")
                                                            .foregroundColor(.black)
                                                            .font(.caption)
                                                    )
                                            }
                                        }
                                    }

                                }.frame(width: width * 0.5, alignment: .leading)
                            }
                        }
                        Button {
                            Analytics.shared.log(event: .review_tapped_tutorial)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            UserDefaults.standard.setValue("signedUp", forKey: K.defaults.onboarding)
                            withAnimation {
                                fromPage = "onboarding2"
                                viewRouter.progressValue += 0.1
                                viewRouter.currentPage = .pricing
                            }
                        } label: {
                            HStack {
                                Text("MindGarden tutorial  👉🏻")
                                    .foregroundColor(Clr.darkgreen)
                                    .font(Font.mada(.semiBold, size: 18))
                            }.frame(width: g.size.width * 0.75, height: g.size.height/16)
                            .background(Clr.yellow)
                            .cornerRadius(25)
                        }.padding(.top, 50)
                        .buttonStyle(NeumorphicPress())
                        Button {
                            Analytics.shared.log(event: .review_tapped_explore)
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            UserDefaults.standard.setValue("done", forKey: K.defaults.onboarding)
                            withAnimation {
                                viewRouter.progressValue += 0.1
                                fromPage = "onboarding2"
                                viewRouter.currentPage = .pricing
                            }
                        } label: {
                            HStack {
                                Text("Explore the app")
                                    .foregroundColor(Clr.black2)
                                    .font(Font.mada(.regular, size: 18))
                            }.frame(width: g.size.width * 0.75, height: g.size.height/16)
                            .background(Clr.darkWhite)
                            .cornerRadius(25)
                        }.padding(.top, 35)
                        .buttonStyle(NeumorphicPress())
                    }
                }
            }
        }
        .transition(.move(edge: .trailing))
        .onAppearAnalytics(event: .screen_load_review)
            .onAppear {
                if UserDefaults.standard.string(forKey: "reason") != nil {
                    switch UserDefaults.standard.string(forKey: "reason") {
                        case "Sleep better":
                            aim = (Img.moon, "Sleep better")
                        case "Get more focused":
                            aim = (Img.target, "Increase focus")
                        case "Managing Stress & Anxiety":
                            aim = (Img.moon, "Control anxiety")
                            default: break
                    }
                }

                if UserDefaults.standard.string(forKey: "experience") != nil {
                switch UserDefaults.standard.string(forKey: "experience") {
                    case "Meditate often":
                        experience = (Img.redTulips3, "is high")
                    case "Have tried to meditate":
                        experience = (Img.redTulips2, "is low")
                    case "Have never meditated":
                        experience = (Img.redTulips1, "is none")
                    default: break
                }
                }
                if UserDefaults.standard.value(forKey: K.defaults.meditationReminder) != nil {
                    notifications = "On for \(displayedTime.string(for: UserDefaults.standard.value(forKey: K.defaults.meditationReminder)) ?? "")"
                } else {
                    notifications = "Off"
                }
            }
    }
}

struct ReviewScene_Previews: PreviewProvider {
    static var previews: some View {
        ReviewScene()
    }
}

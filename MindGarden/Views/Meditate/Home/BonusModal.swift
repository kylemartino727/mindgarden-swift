//
//  BonusModal.swift
//  MindGarden
//
//  Created by Mark Jones on 6/26/21.
//

import SwiftUI

struct BonusModal: View {
    @ObservedObject var bonusModel: BonusViewModel
    @Binding var shown: Bool
    @Binding var coins: Int

    var body: some View {
        GeometryReader { g in
            VStack(spacing: 10) {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center, spacing: 0) {
                        ZStack {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.system(size: 22))
                                    .padding()
                            }.position(x: 30, y: 35)
                            HStack(alignment: .center) {
                                Text("Daily Bonus")
                                    .font(Font.mada(.bold, size: 30))
                                    .foregroundColor(Clr.black1)
                                    .padding()
                            }.padding(.bottom, -5)
                        }.frame(height: g.size.height * 0.08)

                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            if bonusModel.dailyBonus == "" || bonusModel.formatter.date(from: bonusModel.dailyBonus)! - Date() < 0 {
                                Analytics.shared.log(event: .home_claim_daily)
                                bonusModel.saveDaily(plusCoins: 5)
                                coins += 5
                                bonusModel.totalBonuses -= 1
                            }
                        } label: {
                            BonusBox(bonusModel: bonusModel, width: g.size.width, height: g.size.height, video: false)
                        }.padding(.bottom, 10)
                        .buttonStyle(NeumorphicPress())
                        Spacer()
                        if !K.isIpod() {
                            Text("Streaks")
                                .font(Font.mada(.bold, size: 30))
                                .foregroundColor(Clr.black1)
                                .frame(alignment: .center)
                                .padding(.bottom, 5)
                        }
                        ZStack {
                            Rectangle()
                                .fill(Clr.darkWhite)
                                .neoShadow()
                            HStack(spacing: 0) {
                                VStack {
                                    Img.newStar
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Text("\(bonusModel.streakNumber) ").bold().foregroundColor(Clr.black1) + Text(bonusModel.streakNumber == 1 ? "day" : "days").foregroundColor(Clr.black1)
                                }.frame(width: g.size.width * 0.15)
                                .padding()
                                VStack(spacing: -5) {
                                    Text("7 days")
                                        .font(Font.mada(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.center)
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        if bonusModel.sevenDayProgress >= 1.0 {
                                            coins += 30
                                            Analytics.shared.log(event: .home_claim_seven)
                                            bonusModel.saveSeven()
                                        }
                                    } label: {
                                        ProgressBar(width: g.size.width, height: g.size.height, weekly: true, progress: bonusModel.sevenDayProgress)
                                    }.buttonStyle(NeumorphicPress())

                                    Text("30 days")
                                        .font(Font.mada(.bold, size: 20))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.center)
                                        .padding(.top)
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        if bonusModel.thirtyDayProgress >= 1.0 {
                                            Analytics.shared.log(event: .home_claim_thirty)
                                            coins += 100
                                            bonusModel.saveThirty()
                                        }
                                    } label: {
                                        ProgressBar(width: g.size.width, height: g.size.height, weekly: false, progress: bonusModel.thirtyDayProgress)
                                    }.buttonStyle(NeumorphicPress())
                                }
                                .padding()
                            }.padding(.leading)
                        }.frame(width: g.size.width * 0.65, height: g.size.height * 0.25, alignment: .center)
                        Spacer()
                    }
                    .frame(width: g.size.width * 0.85, height: g.size.height * (K.hasNotch() ? 0.55 : 0.6), alignment: .center)
                    .background(Clr.darkWhite)
                    .cornerRadius(12)
                    Spacer()
                } 
                Spacer()
            }
        }
    }
    
    struct ProgressBar: View {
        let width, height: CGFloat
        let weekly: Bool
        let progress: Double

        var body: some View {
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: width/3 , height: height/25)
                    .foregroundColor(Clr.darkWhite)
                Rectangle()
                    .frame(width: min((CGFloat(progress)*width)/3, width/3), height: height/25)
                    .cornerRadius(50)
                    .foregroundColor(Clr.yellow)
                    .animation(.linear)
                HStack {
                    if progress >= 1.0 && !K.isIpod() {
                        Text("CLAIM!")
                            .foregroundColor(Clr.black1)
                            .font(Font.mada(.bold, size: 16))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    } else {
                        Spacer()
                    }
                    Img.coin
                        .renderingMode(.original)
                    Text(weekly ? "30" : "100")
                        .foregroundColor(Clr.black1)
                        .font(Font.mada(.semiBold, size: 16))
                    Spacer()
                }.padding()
                .frame(alignment: .center)
            }
        }
    }

    struct BonusBox: View {
        @ObservedObject var bonusModel: BonusViewModel
        @State private var dailyCooldown = ""
        let width, height: CGFloat
        let video: Bool


        var body: some View {
            ZStack(alignment: .center){
                Rectangle()
                    .fill(Clr.darkWhite)
                    .frame(width: width * 0.65, height: height * 0.07)
                    .cornerRadius(15)
                    .neoShadow()
                HStack {
                    if bonusModel.dailyBonus == "" || bonusModel.formatter.date(from: bonusModel.dailyBonus)! - Date() < 0 {
                        Img.coin
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.07)
                        Text("5")
                            .foregroundColor(Clr.black1)
                            .font(Font.mada(.semiBold, size: 24))
                            .minimumScaleFactor(0.5)
                            .padding(.trailing)
                        Capsule()
                            .fill(Clr.brightGreen)
                            .overlay(
                                Group {
                                    if video {
                                        Image(systemName: "play.fill")
                                            .foregroundColor(.white)
                                    } else {
                                        Text("CLAIM")
                                            .font(Font.mada(.bold, size: 20))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                            )
                            .frame(width: width * 0.3, height: height * 0.04)
                            .padding(.leading)
                            .neoShadow()
                    } else {
                        Text(bonusModel.dailyInterval)
                            .foregroundColor(Clr.darkgreen)
                            .font(Font.mada(.bold, size: 30))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .padding(.trailing)
                    }

                }.padding()
            }
        }
    }
}

struct BonusModal_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            BonusModal(bonusModel: BonusViewModel(userModel: UserViewModel()), shown: .constant(true), coins: .constant(0))
        }
    }
}

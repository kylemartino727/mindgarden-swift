//
//  PurchaseModal.swift
//  MindGarden
//
//  Created by Mark Jones on 6/14/21.
//

import SwiftUI
import StoreKit

struct PurchaseModal: View {
    @Binding var shown: Bool
    @Binding var showConfirm: Bool
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var bonusModel: BonusViewModel
    @EnvironmentObject var meditateModel: MeditationViewModel
//    var img: Img = Image()


    var body: some View {
        GeometryReader { g in
            VStack {
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center) {
                        HStack(alignment: .top) {
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    shown = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.title)
                                    .padding()
                            }
                            Spacer()
                            Text(userModel.willBuyPlant?.title ?? "")
                                .font(Font.mada(.bold, size: 30))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .foregroundColor(Clr.black1)
                                .padding()
                            Spacer()
                            Image(systemName: "xmark")
                                .font(.title)
                                .padding()
                                .opacity(0)
                        }
                        if Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) {
                            userModel.willBuyPlant?.coverImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size.width * 0.325, height: g.size.height * 0.225, alignment: .center)
                        } else {
                            userModel.willBuyPlant?.packetImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: g.size.width * 0.325, height: g.size.height * 0.225, alignment: .center)
                        }
                        HStack(spacing: 5) {
                            Text(" \(userModel.willBuyPlant?.description ?? "")")
                                .font(Font.mada(.semiBold, size: 20))
                                .foregroundColor(Clr.black1)
                        }.padding(.horizontal, 40)
                        .minimumScaleFactor(0.05)
                        .lineLimit(6)
                        HStack(spacing: 10){
//                            userModel.willBuyPlant?.title == "Aloe" || userModel.willBuyPlant?.title == "Monstera" ?
//                            Img.pot
//                            :
                            Img.seed
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.one
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.16)
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.two
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.18)
                            Image(systemName: "arrow.right")
                            userModel.willBuyPlant?.coverImage
                                .resizable() 
                                .aspectRatio(contentMode: .fit)
                                .frame(height: g.size.width * 0.2)
                        }.padding(.horizontal, 10)
                        if Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) {
                            HStack {
                                switch Plant.badgeDict[(userModel.willBuyPlant ?? Plant.plants[0]).price] {
                                case "🙏 30 Gratitudes": Text("Total gratitudes: \(UserDefaults.standard.integer(forKey: "numGrads"))")
                                case "7️⃣ Day Streak": Text("Current Streak: \(bonusModel.streakNumber)")
                                case  "📆 30 Day Streak": Text("Current Streak: \(bonusModel.streakNumber)")
                                default: Text("")
                                }
                            }
                            .font(Font.mada(.semiBold, size: 18))
                            .foregroundColor(Clr.black2)
                            .padding(.bottom, -10)
                        }
                        Button {
                            if Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) {

                                switch Plant.badgeDict[(userModel.willBuyPlant ?? Plant.plants[0]).price] {
                                case "⭐️ Rate the app":
                                    if !UserDefaults.standard.bool(forKey: "tappedRate") {
                                        Analytics.shared.log(event: .store_tapped_rate_app)
                                        withAnimation {
                                            if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
                                                UserDefaults.standard.setValue(true, forKey: "tappedRate")
                                                userModel.buyPlant(unlockedStrawberry: true)
                                            }
                                        }
                                    }
                                case "💌 Refer a friend":
                                    Analytics.shared.log(event: .store_tapped_refer_friend)
                                    withAnimation {
                                        tappedRefer = true
                                        viewRouter.currentPage = .profile
                                    }
                                case "👨‍🌾 Become a pro user":
                                    if !UserDefaults.standard.bool(forKey: "isPro") {
                                        Analytics.shared.log(event: .store_tapped_go_pro)
                                        withAnimation {
                                            fromPage = "store"
                                            viewRouter.currentPage = .pricing
                                        }
                                    }
                                case "🙏 30 Gratitudes":
                                    break
                                default:
                                    meditateModel.selectedMeditation = meditateModel.featuredMeditation
                                    withAnimation {
                                        
                                        if meditateModel.featuredMeditation?.type == .course {
                                            viewRouter.currentPage = .middle
                                        } else {
                                            viewRouter.currentPage = .play
                                        }
                                    }
                                }
                            } else {
                                Analytics.shared.log(event: .store_tapped_purchase_modal_buy)
                                if userCoins >= userModel.willBuyPlant?.price ?? 0 {
                                    withAnimation {
                                        showConfirm = true
                                    }
                                }
                            }
                        } label: {
                            Capsule()
                                .fill(Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) ? Clr.darkgreen : Clr.darkWhite)
                                .frame(width: g.size.width * (Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) ? 0.55 : 0.25), height: g.size.height * 0.05)
                                .neoShadow()
                                .padding()
                                .overlay(HStack{
                                    if Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) {
                                        Text("\(Plant.badgeDict[(userModel.willBuyPlant ?? Plant.plants[0]).price] ?? "" )")
                                            .font(Font.mada(.bold, size: 18))
                                            .foregroundColor(Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) ? .white : Clr.black1)
                                    } else {
                                        Img.coin
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: g.size.width * 0.05, height: g.size.width * 0.05)
                                        Text("\(userModel.willBuyPlant?.price ?? 0)")
                                            .font(Font.mada(.bold, size: Plant.badgePlants.contains(userModel.willBuyPlant ?? Plant.plants[0]) ? 18 : 20))
                                            .foregroundColor( Clr.black1)
                                    }
                                })
                        }
                    }.frame(width: g.size.width * 0.85, height: g.size.height * 0.70, alignment: .top)
                    .background(Clr.darkWhite)
                    .padding(.bottom)
                    .cornerRadius(12)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct PurchaseModal_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDisparateDevices {
            PurchaseModal(shown: .constant(true), showConfirm: .constant(false))
        }
    }
}

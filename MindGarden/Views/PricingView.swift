//
//  PricingView.swift
//  MindGarden
//
//  Created by Mark Jones on 10/26/21.
//

import SwiftUI
import Purchases
import AppsFlyerLib
import Firebase
import FirebaseFirestore
import Amplitude
import WidgetKit

var fromPage = ""
var userWentPro = false

struct PricingView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @State private var selectedPrice = ""
    @State private var packagesAvailableForPurchase = [Purchases.Package]()
    @State private var monthlyPrice = 0.0
    @State private var yearlyPrice = 0.0
    @State private var lifePrice = 0.0
    @State private var selectedBox = "Yearly"
    @State private var question1 = false
    @State private var question2 = false
    @State private var question3 = false
    @State private var trialLength = 3

    let items = [("Regular vs\n Pro", "😔", "🤩"), ("Total # of Meditations", "30", "Infinite"), ("Total # of Gratitudes", "30", "Infinite"), ("Total # of Mood Checks", "30", "Infinite"),("Access to Widgets", "🔒", "✅"), ("Unlock all Meditations", "🔒", "✅"), ("Save data on  the cloud", "🔒", "✅")]
    var body: some View {
            GeometryReader { g in
                let width = g.size.width
                let height = g.size.height
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all)
                    VStack {
                        ScrollView(showsIndicators: false) {
                            ZStack {
                                Img.morningSun
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                    .foregroundColor(.gray)
                                    .padding(.leading, UIScreen.main.bounds.width/1.25)
                                    .padding(.bottom, 100)
                                    .opacity(0.5)
                                    .onTapGesture {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation {
                                            UserDefaults.standard.setValue(true, forKey: "isPro")
                                            UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(true, forKey: "isPro")
                                            WidgetCenter.shared.reloadAllTimelines()
                                            switch fromPage {
                                            case "home": viewRouter.currentPage = .meditate
                                            case "profile": viewRouter.currentPage = .profile
                                            case "onboarding": viewRouter.currentPage = .garden
                                            case "store": viewRouter.currentPage = .shop
                                            case "onboarding2": viewRouter.currentPage = .meditate
                                            case "lockedMeditation": viewRouter.currentPage = .categories
                                            case "middle": viewRouter.currentPage = .middle
                                            case "widget": viewRouter.currentPage = .meditate
                                            default: viewRouter.currentPage = .meditate
                                            }
                                        }
                                        if fromPage == "onboarding2" {
                                            if !UserDefaults.standard.bool(forKey: "isPro") {
                                                let center = UNUserNotificationCenter.current()
                                                let content = UNMutableNotificationContent()
                                                content.title = "Don't Miss This Opportunity 127 users went pro this week!"
                                                content.body = "🎉 MindGarden Pro For Life sale is gone in the Next 12 Hours!!! 🎉"
                                                // Step 3: Create the notification trigger
                                                let date = Date().addingTimeInterval(13200)
                                                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                                // Step 4: Create the request
                                                let uuidString = UUID().uuidString
                                                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                                                // Step 5: Register the request
                                                center.add(request) { (error) in }
                                            }
                                        }
                                    }
                            }.frame(width: g.size.width)
                            //UserDefaults.standard.string(forKey: "reason") == "Sleep better" ? "Get 1% happier every day & sleep better by upgrading to \nMindGarden Pro 🍏"  : UserDefaults.standard.string(forKey: "reason") == "Get more focused" ? "Get 1% happier & more focused every day by upgrading to MindGarden Pro 🍏" : "Get 1% happier & more calm every day by upgrading to MindGarden Pro 🍏
                            (Text("🥳 Get MindGarden Pro with a New Year sale") + Text(" (limited time)").foregroundColor(Clr.darkgreen))
                                .font(Font.mada(.bold, size: 22))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.leading)
                                .frame(width: width * 0.78, alignment: .leading)
                                .padding(15)
//                            Button {
//                                let impact = UIImpactFeedbackGenerator(style: .light)
//                                impact.impactOccurred()
//                                selectedBox = "Lifetime"
//                                unlockPro()
//                            } label: {
//                                PricingBox(title: "Lifetime", price: lifePrice, selected: $selectedBox)
//                            }.buttonStyle(NeumorphicPress())
//                                .frame(width: width * 0.8, height: height * 0.08)
//                                .padding(5)

                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedBox = "Yearly"
                                unlockPro()
                            } label: {
                                ZStack {
                                    PricingBox(title: "Yearly", price: yearlyPrice, selected: $selectedBox,trialLength: $trialLength)
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Clr.yellow)
                                        .overlay(
                                            Text("Most Popular")
                                                .foregroundColor(Color.black.opacity(0.8))
                                                .font(Font.mada(.bold, size: 12))
                                                .multilineTextAlignment(.center)
                                                .minimumScaleFactor(0.05)
                                                .lineLimit(1)
                                                .padding(.horizontal, 1)
                                        )
                                        .frame(width: 90,height: 25, alignment: .leading)
                                        .position(x: width * 0.65)
                                }
                            }.buttonStyle(NeumorphicPress())
                                .frame(width: width * 0.8, height: height * 0.08)
                                .padding(5)

                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedBox = "Monthly"
                                unlockPro()

                            } label: {
                                PricingBox(title: "Monthly", price: monthlyPrice, selected: $selectedBox, trialLength: $trialLength)
                            }.buttonStyle(NeumorphicPress())
                                .frame(width: width * 0.8, height: height * 0.08)
                                .padding(5)


                            Section() {
                                VStack(alignment: .trailing, spacing: 0){
                                        ForEach(items, id: \.0){ item in
                                            HStack() {
                                                if item.1 == "😔" {
                                                    Text("\(item.0)")
                                                        .foregroundColor(Clr.black2)
                                                        .font(Font.mada(.bold, size: 16))
                                                        .frame(width: width * 0.3, alignment: .center)
                                                        .lineLimit(2)
                                                        .minimumScaleFactor(0.05)
                                                        .multilineTextAlignment(.center)
                                                } else {
                                                    Text("\(item.0)")
                                                        .foregroundColor(Clr.darkgreen)
                                                        .font(Font.mada(.semiBold, size: 16))
                                                        .frame(width: width * 0.25, alignment: .leading)
                                                        .lineLimit(2)
                                                        .minimumScaleFactor(0.05)
                                                        .multilineTextAlignment(.leading)
                                                }
                                                Divider()
                                                Text("\(item.1)")
                                                    .font(Font.mada(.regular, size: item.1 == "😔" || item.1 == "🔒" ? 32 : 18))
                                                    .frame(width: width * 0.175)


                                                Divider()
                                                if item.2 == "Infinite" {
                                                    Text("∞")
                                                        .font(Font.mada(.regular, size: 36))
                                                        .frame(width: width * 0.175)
                                                } else {
                                                    Text("\(item.2)")
                                                        .font(Font.mada(.regular, size: item.2 == "🤩" ? 32 : 32))
                                                        .frame(width: width * 0.175)
                                                }
                                                // etc
                                            }
                                            Divider()
                                        }
                                    }

                                .padding()
                                    .background(RoundedRectangle(cornerRadius: 14)
                                                    .fill(Clr.darkWhite)
                                                    .frame(width: width * 0.8, height: height * 0.55)
                                                    .neoShadow())
                                }.frame(width: width * 0.8, height: height * 0.6)
                            Text("Don't just take it from us\n⭐️⭐️⭐️⭐️⭐️")
                                .font(Font.mada(.bold, size: 22))
                                .foregroundColor(Clr.black2)
                                .multilineTextAlignment(.center)
                                .padding(.top)
                            SnapCarousel()
                                .padding(.bottom)
                                .environmentObject(UIStateModel())
                            VStack {
                                Text("👨‍🌾 Invest in MindGarden,\nhelp build these features & support mental health")
                                    .font(Font.mada(.bold, size: 22))
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.center)
                                    .frame(width: width * 0.8)
                                    .padding(.top)
                                ZStack {
                                    Img.investMg
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: width * 0.70)
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 14)
                                                        .fill(Clr.darkWhite)
                                                        .frame(width: width * 0.80)
                                                        .neoShadow())
                                }
                                Button {
                                    guard let url = URL(string: "https://tally.so/r/3xRxkn") else { return }
                                     UIApplication.shared.open(url)
                                } label: {
                                    HStack {
                                        Text("Are you a student & can't \nafford pro? ") + Text("Let us know").foregroundColor(Clr.brightGreen).bold()
                                    }.frame(width: width * 0.8)
                                        .foregroundColor(Clr.black2)
                                }.padding([.horizontal, .top])
                            }.padding(.top, 20)
                            VStack {
                                Text("🙋‍♂️ Frequent Asked Questions")
                                    .font(Font.mada(.bold, size: 22))
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical)
                                    .padding(.top, 10)
                                Text("\(question1 ? "🔽" : "▶️") How does the pro plan help me?")
                                    .font(Font.mada(.bold, size: 18))
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: width * 0.8, alignment: .leading)
                                    .onTapGesture {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            question1.toggle()
                                        }
                                    }
                                if question1 {
                                    Text("Pro users are 72% more likely to stick with meditation vs non pro users. You have no limits for moods, gratitudes, and meditations. You feel invested, so you make sure to use the app daily.")
                                        .font(Font.mada(.semiBold, size: 16))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: width * 0.8, alignment: .leading)
                                        .padding(.leading, 5)
                                }
                                Divider()
                                Text("\(question2 ? "🔽" : "▶️") How do app subscriptions work?")
                                    .font(Font.mada(.bold, size: 18))
                                    .frame(width: width * 0.8, alignment: .leading)
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.leading)
                                    .onTapGesture {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            question2.toggle()
                                        }
                                    }
                                if question2 {
                                    Text("With a subscription you pay access to pro features that last for either a month or a year. Yearly plans have a 7 day free trial where you won't be billed until the trial is over. Lifetime plans are paid once and last forever.")
                                        .font(Font.mada(.semiBold, size: 16))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: width * 0.8, alignment: .leading)
                                        .padding(.leading, 5)
                                }
                                Divider()
                                Text("\(question3 ? "🔽" : "▶️") How do I cancel my subscription?")
                                    .font(Font.mada(.bold, size: 18))
                                    .frame(width: width * 0.8, alignment: .leading)
                                    .foregroundColor(Clr.black2)
                                    .multilineTextAlignment(.leading)
                                    .onTapGesture {
                                        withAnimation {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            question3.toggle()
                                        }
                                    }
                                if question3 {
                                    Text("You can easily cancel your subscription by going to the Settings App of your iphone and after selecting your apple ID, select subscriptions and simply click on MindGarden.")
                                        .font(Font.mada(.semiBold, size: 16))
                                        .foregroundColor(Clr.black1)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: width * 0.8, alignment: .leading)
                                        .padding(.leading, 5)
                                }
                            }.padding(.bottom, 25)
                        }
                        Spacer()
                        VStack {
                            Button {
                                unlockPro()
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } label: {
                                HStack {
                                    Text(selectedBox == "Yearly" ? "👨‍🌾 Start your free trial" : "👨‍🌾 Unlock MindGarden Pro")
                                        .foregroundColor(Clr.darkgreen)
                                        .font(Font.mada(.bold, size: 18))
                                }.frame(width: g.size.width * 0.825, height: 50)
                                .background(Clr.yellow)
                                .cornerRadius(25)
                            }.buttonStyle(NeumorphicPress())

                            HStack {
                                Text("Privacy Policy")
                                    .foregroundColor(.gray)
                                    .font(Font.mada(.regular, size: 14))
                                    .onTapGesture {
                                        if let url = URL(string: "https://www.termsfeed.com/live/5201dab0-a62c-484f-b24f-858f2c69e581") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                Spacer()
                                Text("Terms of Service")
                                    .foregroundColor(.gray)
                                    .font(Font.mada(.regular, size: 14))
                                    .onTapGesture {
                                        if let url = URL(string: "https:/mindgarden.io/terms-of-use") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                            }.padding(.horizontal)
                        }.padding(10)
                            .padding(.bottom, K.isPad() ? 50 : K.isSmall() ? 45 : 0)
                        Spacer()
                    }.padding(.top, K.hasNotch() ? 30 : 10)
                }
            }.onAppear {
                Purchases.shared.offerings { [self] (offerings, error) in
                    if let offerings = offerings {
                        let offer = offerings.current
                        let packages = offer?.availablePackages
                        guard packages != nil else {
                            return
                        }
                        for i in 0...packages!.count - 1 {
                            let package = packages![i]
                            self.packagesAvailableForPurchase.append(package)
                            let product = package.product
                            let price = product.price
                            if let period = product.introductoryPrice?.subscriptionPeriod {
                                 trialLength = period.numberOfUnits
                              }
                            let name = product.productIdentifier

                            if name == "io.mindgarden.pro.monthly" {
                                monthlyPrice = round(100 * Double(truncating: price))/100
                            } else if name == "io.mindgarden.pro.yearly" {
                                yearlyPrice = round(100 * Double(truncating: price))/100
                            } else if name == "io.mindgarden.pro.lifetime" {
                                lifePrice = round(100 * Double(truncating: price))/100
                            }
                        }
                    }
                }
            }
            .onAppearAnalytics(event: .screen_load_pricing)
    }

    private func unlockPro() {
        var price = 0.0
        var package = packagesAvailableForPurchase[0]
        var event2 = "_Started_From_All"
        var event3 = "cancelled_"
        switch selectedBox {
        case "Yearly":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.mindgarden.pro.yearly"
            }!
            price = yearlyPrice
            event2 = "Yearly" + event2
            event3 += "yearly"
        case "Lifetime":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.mindgarden.pro.lifetime"
            }!
            price = lifePrice
            event2 = "Lifetime" + event2
            event3 += "lifetime"
        case "Monthly":
            package = packagesAvailableForPurchase.last { (package) -> Bool in
                return package.product.productIdentifier == "io.mindgarden.pro.monthly"
            }!
            price = monthlyPrice
            event2 = "Monthly" + event2
            event3 += "monthly"
        default: break
        }

        Purchases.shared.purchasePackage(package) { [self] (transaction, purchaserInfo, error, userCancelled) in
            if purchaserInfo?.entitlements.all["isPro"]?.isActive == true {
                let event = logEvent()

                let revenue = AMPRevenue().setProductIdentifier(event)
                revenue?.setPrice(NSNumber(value: price))
                if !event.contains("yearly") {
                    AppsFlyerLib.shared().logEvent(name: event, values:
                                                    [
                                                        AFEventParamRevenue: price,
                                                        AFEventParamCurrency:"\(Locale.current.currencyCode!)"
                                                    ])
                    Amplitude.instance().logRevenueV2(revenue!)
                } else {
                    AppsFlyerLib.shared().logEvent(name: event, values:
                                                                    [
                                                                        AFEventParamContent: "true"
                                                                    ])
                }
                AppsFlyerLib.shared().logEvent(name: event2, values:
                                                                [
                                                                    AFEventParamContent: "true"
                                                                ])
                userIsPro()
            } else if userCancelled {
                AppsFlyerLib.shared().logEvent(name: event3, values:
                                                [
                                                    AFEventParamContent: "true"
                                                ])
            }
        }
    }
    private func userIsPro() {
        userModel.willBuyPlant = Plant.badgePlants.first(where: { plant in plant.title == "Bonsai Tree" })
        userModel.buyPlant(unlockedStrawberry: true)
        UserDefaults.standard.setValue(true, forKey: "bonsai")
        UserDefaults.standard.setValue(true, forKey: "isPro")
        UserDefaults(suiteName: "group.io.bytehouse.mindgarden.widget")?.setValue(true, forKey: "isPro")
        WidgetCenter.shared.reloadAllTimelines()
        if fromPage != "onboarding2" {
            userWentPro = true
            if let _ = Auth.auth().currentUser?.email {
                let email = Auth.auth().currentUser?.email
                Firestore.firestore().collection(K.userPreferences).document(email!).updateData([
                    "isPro": true,
                ]) { (error) in
                    if let e = error {
                        print("There was a issue saving data to firestore \(e) ")
                    } else {
                        print("Succesfully saved new items")
                    }
                }
            }
        } else {
            viewRouter.currentPage = .meditate
        }
    }
    private func logEvent(cancelled: Bool = false) -> String {
            var event = ""

            switch selectedBox {
            case "Yearly":
                event = "yearly_started_from_"
            case "Lifetime":
                event = "lifetime_started_from_"
            case "Monthly":
                event = "monthly_started_from_"
            default: break
            }

            if cancelled {
                event = "cancelled_" + event
            }
            if fromPage == "onboarding" {
                event = event + "onboarding"
            } else if fromPage == "onboarding2" {
                    event = event + "onboarding2"
            } else if fromPage == "profile" {
                event = event + "profile"
            } else if fromPage == "home" {
                event = event + "from_Home"
            } else if fromPage == "plusMeditation" {
                event = event + "Plus_Meditations"
            } else if fromPage == "plusMood" {
                event = event + "Plus_Mood"
            } else if fromPage == "plus_Gratitude" {
                event = event + "PlusGratitude"
            } else if fromPage == "lockedMeditation" {
                event = event + "Locked_Meditation"
            } else if fromPage == "middle" {
                event = event + "Middle_Locked"
            } else if fromPage == "store" {
                event = event + "fromStore"
            } else if fromPage == "widget" {
                event = event + "fromWidget"
            }
            return event
        }


    struct PricingBox: View {
        let title: String
        let price: Double
        @Binding var selected: String
        @Binding var trialLength: Int

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(selected == title ? Clr.darkgreen : Clr.darkWhite)
//                    .border(Clr.yellow, width: selected == title ? 4 : 0)
                HStack {
                    VStack(alignment: .leading, spacing: -2){
                    Text("\(title)")
                        .foregroundColor(selected == title ? .white : Clr.darkgreen)
                        .font(Font.mada(.semiBold, size: 20))
                        .lineLimit(1)
                        .minimumScaleFactor(0.05)
                        .multilineTextAlignment(.leading)
                        HStack(spacing: 2) {
                            if title == "Yearly" {
                                (Text(Locale.current.currencySymbol ?? "$") + Text("\(price * 2 + 0.01, specifier: "%.2f")"))
                                    .strikethrough(color: Color("lightGray"))
                                    .foregroundColor(Color("lightGray"))
                                    .font(Font.mada(.regular, size: 16))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                    .multilineTextAlignment(.leading)
                            }
                            (Text(Locale.current.currencySymbol ?? "$") + Text("\(price, specifier: "%.2f")"))
                                .foregroundColor(selected == title ? .white : Clr.darkgreen)
                                .font(Font.mada(.regular, size: 16))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.leading)
                        }.frame(width: 100, alignment: .leading)


                    }.padding(.leading, 20)
                    .frame(width: 110)
                    if title == "Lifetime" || title == "Yearly" {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Clr.yellow)
                            .overlay(
                                Text(title == "Yearly" ? "\(trialLength == 1 ? "7" : "3") day\nfree trial" : "50% OFF")
                                    .foregroundColor(Color.black.opacity(0.8))
                                    .font(Font.mada(.bold, size: 12))
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.05)
                                    .lineLimit(2)
                                    .padding(.horizontal, 1)
                            )
                            .frame(width: 60,height: 35, alignment: .leading)
                    }
                    Spacer()

                        (Text((Locale.current.currencySymbol ?? "($")) + Text(title == "Yearly" ? "\(((round(100 * (price/12))/100) - 0.01), specifier: "%.2f")" : title == "Monthly" ? "\(price, specifier: "%.2f")" : "0.00") + Text("/mo")
                       )
                            .foregroundColor(selected == title ? .white : Clr.black2)
                            .font(Font.mada(.bold, size: 20))
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                    }.padding(.trailing)
            }
        }
    }
}


struct PricingView_Previews: PreviewProvider {
    static var previews: some View {
        PricingView()
    }
}

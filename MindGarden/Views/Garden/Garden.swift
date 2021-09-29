//
//  Garden.swift
//  MindGarden
//
//  Created by Mark Jones on 6/19/21.
//

import SwiftUI

struct Garden: View {
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var isMonth: Bool = true
    @State private var showSingleModal = false
    @State private var day: Int = 0
    @State private var topThreePlants: [FavoritePlant] = [FavoritePlant]()
    @State private var isOnboarding = false
    @State private var tileOpacity = 1.0
    @State private var gotItOpacity = 1.0
    @State private var forceRefresh = false
    @State private var color = Clr.yellow

    var body: some View {
        GeometryReader { gp in
            ScrollView(showsIndicators: false) {
                ZStack {
                    VStack(alignment: .center, spacing: 20) {
                        //Version 2
                        //                    HStack(spacing: 40) {
                        //                        Button {
                        //                            isMonth = true
                        //                        } label: {
                        //                            MenuButton(title: "Month", isMonth: isMonth)
                        //                        }
                        //                        Button {
                        //                            isMonth = false
                        //                        } label: {
                        //                            MenuButton(title: "Year", isMonth: !isMonth)
                        //                        }
                        //                    }
                        Text("👨‍🌾 Your MindGarden")
                            .font(Font.mada(.semiBold, size: 22))
                            .foregroundColor(Clr.darkgreen)
                            .padding()
                        HStack {
                            Text("\(Date().getMonthName(month: String(gardenModel.selectedMonth))) \(String(gardenModel.selectedYear))")
                                .font(Font.mada(.bold, size: 30))
                            Spacer()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .garden_previous_month)
                                if gardenModel.selectedMonth == 1 {
                                    gardenModel.selectedMonth = 12
                                    gardenModel.selectedYear -= 1
                                } else {
                                    gardenModel.selectedMonth -= 1
                                }
                                gardenModel.populateMonth()
                                getFavoritePlants()
                            } label: {
                                OperatorButton(imgName: "lessthan.square.fill")
                            }
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                Analytics.shared.log(event: .garden_next_month)
                                if gardenModel.selectedMonth == 12 {
                                    gardenModel.selectedMonth = 1
                                    gardenModel.selectedYear += 1
                                } else {
                                    gardenModel.selectedMonth += 1
                                }
                                gardenModel.populateMonth()
                                getFavoritePlants()
                            } label: {
                                OperatorButton(imgName: "greaterthan.square.fill")
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, -15)
                        .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" ? 1 : 0.1 : 1)
                        GridStack(rows: 5, columns: 7) { row, col in
                            ZStack {
                                let c = gardenModel.placeHolders
                                if col < c && row == 0 {
                                    Rectangle()
                                        .fill(Clr.dirtBrown)
                                        .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                        .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                                        .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" ? 0.5 : 1 : 1)
                                } else {
                                    if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.0 != nil && gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.1 != nil {
                                        // mood & plant both exist
                                        // first tile in onboarding
                                        let plantHead = gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.0?.head
                                        ZStack {
                                            Rectangle()
                                                .fill(gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.1?.color ?? Clr.dirtBrown)
                                                .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                                .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                                                //if onboarding
                                                .opacity(isOnboarding ? tileOpacity : 1)
                                                .animation(Animation.easeInOut(duration:0.5).repeatForever(autoreverses:true), value: tileOpacity)
                                            plantHead
                                                .padding(3)
                                        }
                                    } else if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.0 != nil { // only mood is nil
                                        ZStack {
                                            let plantHead = gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.0?.head
                                            Rectangle()
                                                .fill(Clr.dirtBrown)
                                                .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                                .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                                            plantHead
                                                .padding(3)
                                        }
                                    } else if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.1 != nil { // only plant is nil
                                        Rectangle()
                                            .fill(gardenModel.monthTiles[row]?[col + (row * 7) + 1 - c]?.1?.color ?? Clr.dirtBrown)
                                            .frame(width:  gp.size.width * 0.12, height:  gp.size.width * 0.12)
                                            .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                                    } else { //both are nil
                                        ZStack {
                                            Rectangle()
                                                .fill(Clr.dirtBrown)
                                                .frame(width: gp.size.width * 0.12, height: gp.size.width * 0.12)
                                                .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 4)
                                                .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" ? 0.5 : 1 : 1)
                                        }
                                    }
                                }
                            }.onTapGesture {
                                Analytics.shared.log(event: .garden_tapped_single_day)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                day = col + (row * 7) + 1  - gardenModel.placeHolders
                                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" {
                                    if gardenModel.monthTiles[row]?[col + (row * 7) + 1 - gardenModel.placeHolders]?.0 != nil && gardenModel.monthTiles[row]?[col + (row * 7) + 1 - gardenModel.placeHolders]?.1 != nil  {
                                        Analytics.shared.log(event: .onboarding_finished_single)
                                        showSingleModal = true
                                        isOnboarding = false
                                        UserDefaults.standard.setValue("single", forKey: K.defaults.onboarding)
                                    }
                                } else {
                                    if day <= 31 && day >= 1 {
                                        if !isOnboarding {
                                            showSingleModal = true
                                        }
                                    }
                                }

                            }
                        }.offset(y: -10)
                        .opacity(isOnboarding ? (UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" ||  UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats") ? 1 : 0.1 : 1)
                        .zIndex(-1000)
                        HStack(spacing: 5) {
                            VStack(spacing: 15) {
                                StatBox(label: "Total Mins", img: Img.iconTotalTime, value: gardenModel.totalMins/60 == 0 && gardenModel.totalMins != 0 ? "0.5" : "\(gardenModel.totalMins/60)")
                                StatBox(label: "Total Sessions", img: Img.iconSessions, value: "\(gardenModel.totalSessions)")
                            }
                            .frame(maxWidth: gp.size.width * 0.33)
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(15)
                                    .neoShadow()
                                VStack(spacing: 10) {
                                    HStack(alignment: .bottom) {
                                        MoodImage(mood: .happy, value: gardenModel.totalMoods[.happy] ?? 0)
                                        MoodImage(mood: .sad, value: gardenModel.totalMoods[.sad] ?? 0)
                                    }.padding(.horizontal, 10)
                                    HStack(alignment: .bottom) {
                                        MoodImage(mood: .okay, value: gardenModel.totalMoods[.okay] ?? 0)
                                        MoodImage(mood: .angry, value: gardenModel.totalMoods[.angry] ?? 0)
                                    }.padding(.horizontal, 10)
                                }
                            }.frame(maxWidth: gp.size.width * 0.47)
                        }.frame(maxHeight: gp.size.height * 0.16)
                        .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" ? 1 : 0.1 : 1)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Favorite Plants:")
                                .foregroundColor(Clr.black2)
                                .font(Font.mada(.semiBold, size: forceRefresh ? 20 : 20.1))
                                .padding(.leading, 5)
                            ZStack {
                                Rectangle()
                                    .fill(Clr.darkWhite)
                                    .cornerRadius(15)
                                    .neoShadow()
                                    .frame(maxWidth: gp.size.width * 0.8)
                                HStack(spacing: 20){
                                    Spacer()
                                    if topThreePlants.isEmpty {
                                        Text("You have no favorite plants")
                                            .foregroundColor(Clr.black2)
                                            .font(Font.mada(.semiBold, size: 20))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.05)
                                            .padding()
                                    } else {
                                        if !topThreePlants.isEmpty, let favPlant1 = topThreePlants[0] {
                                            favPlant1
                                        }
                                        if topThreePlants.count > 1, let favPlant2 = topThreePlants[1] {
                                            favPlant2
                                        }
                                        if topThreePlants.indices.contains(2), let favPlant3 = topThreePlants[2] {
                                            favPlant3
                                        }
                                    }
                                    Spacer()
                                }
                            }.frame(maxWidth: gp.size.width * 0.8, maxHeight: gp.size.height * 0.4)
                        }.padding(.vertical, 15)
                        .opacity(isOnboarding ? UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" ? 1 : 0.1 : 1)
                    }.padding(.horizontal, 25)
                    .padding(.vertical, 15)
                    .padding(.top, 30)
                    if isOnboarding && (UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" ){
                        VStack(spacing: 0) {
                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                                Triangle()
                                    .fill(Clr.yellow)
                                    .frame(width: 40, height: 20)
                            }
                            Rectangle()
                                .fill(Clr.yellow)
                                .frame(width: 250, height: 140)
                                .overlay(
                                    VStack {
                                        Text(UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate"  ? "📅 This is your calendar view of the month (color of the tile = your mood)" : "📊 These are your monthly statistics")
                                            .font(Font.mada(.semiBold, size: 18))
                                            .lineLimit(3)
                                            .minimumScaleFactor(0.05)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 5)
                                            .foregroundColor(Color.black)
                                        Text("Got it")
                                            .foregroundColor(Color.white)
                                            .colorMultiply(self.color)
                                            .font(Font.mada(.bold, size: 18))
                                            .onAppear {
                                                withAnimation {
                                                    self.color = Clr.darkgreen
                                                }
                                            }
                                            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses:true), value: self.color)
                                            .onTapGesture {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                withAnimation {
                                                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                                                        Analytics.shared.log(event: .onboarding_finished_calendar)
                                                        UserDefaults.standard.setValue("calendar", forKey: K.defaults.onboarding)
                                                    } else if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" {
                                                        UserDefaults.standard.setValue("stats", forKey: K.defaults.onboarding)
                                                        tileOpacity = 0.2
                                                        Analytics.shared.log(event: .onboarding_finished_stats)
                                                    }
                                                    forceRefresh.toggle()
                                                }
                                            }
                                    }.padding()
                                )
                                .cornerRadius(12)
                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" {
                                Triangle()
                                    .fill(Clr.yellow)
                                    .frame(width: 40, height: 20)
                                    .rotationEffect(.radians(.pi))
                            }
                        }.offset(y: UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" ? gp.size.height * 0.1 : gp.size.height * -0.03)
                    }

                }
            }
            .sheet(isPresented: $showSingleModal) {
                SingleDay(showSingleModal: $showSingleModal, day: $day, month: gardenModel.selectedMonth, year: gardenModel.selectedYear)
                    .environmentObject(gardenModel)
                    .navigationViewStyle(StackNavigationViewStyle())
            }
            .onAppear {
                getFavoritePlants()
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "meditate" {
                    isOnboarding = true
                }
            }
            .onAppearAnalytics(event: .screen_load_garden)
        }
    }
    private func getFavoritePlants() {
        topThreePlants = [FavoritePlant]()
        let topThreeStrings = gardenModel.favoritePlants.sorted { $0.value > $1.value }.prefix(3)
        for str in topThreeStrings {
            if let plnt = Plant.allPlants.first(where: { plt in
                plt.title == str.key
            }) {
                topThreePlants.append(FavoritePlant(title: str.key, count: str.value,
                                                    img: plnt.coverImage))
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}


//MARK: - preview
struct Garden_Previews: PreviewProvider {
    static var previews: some View {
        Garden().environmentObject(GardenViewModel())
    }
}

//MARK: - components
struct MoodImage: View {
    let mood: Mood
    let value: Int

    var body: some View {
        HStack(spacing: 0) {
            K.getMoodImage(mood: mood)
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .center) {
                Text(mood.title)
                    .font(.subheadline)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Text(String(value))
                    .font(.headline)
                    .bold()
            }.padding(.leading, 3)
            .frame(maxWidth: 40)
        }.padding(3)
    }
}

struct MenuButton: View {
    var title: String
    var isMonth: Bool

    var body: some View {
        ZStack {
            Capsule()
                .fill(isMonth ? Clr.gardenGreen : Clr.darkWhite)
                .frame(width: 100, height: 35)
                .neoShadow()
            Text(title)
                .font(Font.mada(.regular, size: 16))
                .foregroundColor(isMonth ? .white : Clr.black1)
        }
    }
}

struct OperatorButton: View {
    let imgName: String

    var body: some View {
        Image(systemName: imgName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Clr.darkgreen)
            .foregroundColor(Clr.darkWhite)
            .cornerRadius(10)
            .frame(height: 35)
            .neoShadow()
    }
}

struct FavoritePlant: View {
    let title: String
    let count: Int
    let img: Image

    var body: some View {
        VStack(spacing: 0) {
            img
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Clr.darkgreen))
            HStack {
                Text("\(title)")
                    .font(Font.mada(.regular, size: 16))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("\(count)").bold()
                    .font(Font.mada(.bold, size: 16))
            }.padding(.top, 8)
        }.frame(width: 70, height: 120)
        .padding(10)
    }
}

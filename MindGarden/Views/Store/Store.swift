//
//  Store.swift
//  MindGarden
//
//  Created by Mark Jones on 6/14/21.
//

import SwiftUI

struct Store: View {
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var bonusModel: BonusViewModel
    @State var showModal = false
    @State var confirmModal = false
    @State var showSuccess = false
    var isShop: Bool = true
    @Binding var showPlantSelect: Bool
    @State var isStore = false
    @State private var showTip = false
    var body: some View {
        ZStack {
            Clr.darkWhite.edgesIgnoringSafeArea(.all)
            GeometryReader { g in
                ScrollView(showsIndicators: false) {
                    if isShop {
                        HStack(spacing: 25) {
                            Spacer()
                            Button {
                                Analytics.shared.log(event: .store_tapped_store_option)
                                withAnimation {
                                    isStore = true
                                }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } label: {
                                MenuButton(title: "Store", isStore: isStore)
                            }
                            Button {
                                Analytics.shared.log(event: .store_tapped_badges_option)
                                withAnimation {
                                    isStore = false
                                }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } label: {
                                MenuButton(title: "Badges", isStore: !isStore)
                            }
                            Spacer()
                        }.padding(.top, 50)
                        .padding(.bottom, 0)
                    }
                    HStack(alignment: .top, spacing: 20) {
                        if K.isPad() {
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: -10) {
                            HStack {
                                if !isShop {
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        showPlantSelect = false
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20)
                                            .foregroundColor(Clr.black1)
                                            .padding(.leading)
                                    }
                                }
                                Text(isShop ? !isStore ? "Badges\n🏆🎖🥇" : "🌻 Seed\nShop" : "🌻 Plant Select")
                                    .font(Font.mada(.bold, size: 32))
                                    .minimumScaleFactor(0.005)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Clr.black1)
                                    .padding(.horizontal, isShop ? 25 : 10)
                                    .frame(width: g.size.width * (isShop ? 0.4 : 0.25), alignment: .center)
                            }
                            if isShop && !isStore {
                                ForEach(Plant.badgePlants.prefix(Plant.badgePlants.count/2),  id: \.self) { plant in
                                    Button {
                                        Analytics.shared.log(event: .store_tapped_badge_tile)
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        userModel.willBuyPlant = plant
                                        withAnimation {
                                            showModal = true
                                        }
                                    } label: {
                                        if userModel.ownedPlants.contains(plant) {
                                            PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isOwned: true, isBadge: true)
                                        } else {
                                            PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isBadge: true)
                                        }
                                    }.buttonStyle(NeumorphicPress())
                                }
                            } else {
                                ForEach(isShop ? Plant.plants.prefix(Plant.plants.count/2) : userModel.ownedPlants.prefix(userModel.ownedPlants.count/2), id: \.self)
                                { plant in
                                    if userModel.ownedPlants.contains(plant) && isShop {
                                        PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isOwned: true)
                                    } else {
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            if isShop {
                                                userModel.willBuyPlant = plant
                                                withAnimation {
                                                    showModal = true
                                                }
                                            } else {
                                                UserDefaults.standard.setValue(plant.title, forKey: K.defaults.selectedPlant)
                                                userModel.selectedPlant = plant
                                            }
                                        } label: {
                                            PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop)
                                        }.buttonStyle(NeumorphicPress())
                                    }
                                }
                            }
                        }

                        VStack {
                            HStack {
                                Img.coin
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 25)
                                    .padding(5)
                                Text(String(userCoins))
                                    .font(Font.mada(.semiBold, size: 24))
                                    .foregroundColor(Clr.black1)
                            }.padding(.bottom, -10)
                            if isShop && !isStore {
                                ForEach(Plant.badgePlants.suffix(Plant.badgePlants.count/2 + (Plant.badgePlants.count % 2 == 0 ? 0 : 1)), id: \.self) { plant in
                                    Button {
                                        Analytics.shared.log(event: .store_tapped_badge_tile)
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        userModel.willBuyPlant = plant
                                        withAnimation {
                                            showModal = true
                                        }
                                    } label: {
                                        if userModel.ownedPlants.contains(plant) {
                                            PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isOwned: true, isBadge: true)
                                        } else {
                                            PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isBadge: true)
                                        }
                                    }.buttonStyle(NeumorphicPress())
                                }
                            } else {
                                ForEach(isShop ? Plant.plants.suffix(Plant.plants.count/2 + (Plant.plants.count % 2 == 0 ? 0 : 1))
                                        : userModel.ownedPlants.suffix(userModel.ownedPlants.count/2 + (userModel.ownedPlants.count % 2 == 0 ? 0 : 1)), id: \.self) { plant in
                                    if userModel.ownedPlants.contains(plant) && isShop {
                                        PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop, isOwned: true)
                                    } else {
                                        Button {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            if isShop {
                                                Analytics.shared.log(event: .store_tapped_plant_tile)
                                                userModel.willBuyPlant = plant
                                                withAnimation {
                                                    showModal = true
                                                }
                                            } else {
                                                UserDefaults.standard.setValue(plant.title, forKey: K.defaults.selectedPlant)
                                                userModel.selectedPlant = plant
                                                Analytics.shared.log(event: .home_selected_plant)
                                            }
                                        } label: {
                                            PlantTile(width: g.size.width, height: g.size.height, plant: plant, isShop: isShop)
                                        }.buttonStyle(NeumorphicPress())
                                    }
                                }
                            }

                        }
                        if K.isPad() {
                            Spacer()
                        }
                    }.padding()
                }.padding(.top)
                    .opacity(confirmModal ? 0.3 : 1)
                if showModal || confirmModal {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                }
                if isShop {
                    PurchaseModal(shown: $showModal, showConfirm: $confirmModal).offset(y: showModal ? 0 : g.size.height)
                        .opacity(confirmModal || showSuccess ? 0.3 : 1)
                        .environmentObject(bonusModel)
                }

                ConfirmModal(shown: $confirmModal, showSuccess: $showSuccess).offset(y: confirmModal ? 0 : g.size.height)
                    .opacity(showSuccess ? 0.3 : 1)
                SuccessModal(showSuccess: $showSuccess, showMainModal: $showModal).offset(y: showSuccess ? 0 : g.size.height)
            }.padding(.top)
                .alert(isPresented: $showTip) {
                    Alert(title: Text("💡 Quick Tip"), message:
                            Text("You can click on badges and open them up")
                          , dismissButton: .default(Text("Got it!")))
                }
        }.onAppearAnalytics(event: .screen_load_store)
            .onAppear {
                if UserDefaults.standard.bool(forKey: "christmasLink") {
                    userModel.willBuyPlant = Plant.badgePlants.first(where: {$0.title == "Christmas Tree"})
                    withAnimation {
                        showModal = true
                    }
                    UserDefaults.standard.setValue(true, forKey: "showTip")
                    UserDefaults.standard.setValue(false, forKey: "christmasLink")
                }
                if isShop {
                    showTip = !UserDefaults.standard.bool(forKey: "showTip")
                }
            }
            .onDisappear {
                UserDefaults.standard.setValue(true, forKey: "showTip")
            }
    }

    struct SuccessModal: View {
        @EnvironmentObject var userModel: UserViewModel
        @Binding var showSuccess: Bool
        @Binding var showMainModal: Bool

        var  body: some View {
            GeometryReader { g in
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("Successfully Unlocked!")
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.vertical)
                            Text("Go to the home screen and press the select plant button to equip your new plant")
                                .font(Font.mada(.medium, size: 18))
                                .foregroundColor(Clr.black2.opacity(0.7))
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Button {
                                Analytics.shared.log(event: .store_tapped_success_modal_okay)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    showSuccess = false
                                    showMainModal = false
                                }
                            } label: {
                                Text("Got it")
                                    .font(Font.mada(.bold, size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: g.size.width/3, height: 40)
                                    .background(Clr.darkgreen)
                                    .clipShape(Capsule())
                                    .padding()
                                    .neoShadow()
                            }
                        }.frame(width: g.size.width * 0.85, height: g.size.height * 0.30, alignment: .center)
                            .background(Clr.darkWhite)
                            .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

    struct MenuButton: View {
        var title: String
        var isStore: Bool

        var body: some View {
            ZStack {
                Capsule()
                    .fill(isStore ? Clr.gardenGreen : Clr.darkWhite)
                    .frame(width: 100, height: 35)
                    .neoShadow()
                Text(title)
                    .font(Font.mada(.regular, size: 16))
                    .foregroundColor(isStore ? .white : Clr.black1)
            }
        }
    }
    struct ConfirmModal: View {
        @EnvironmentObject var userModel: UserViewModel
        @Binding var shown: Bool
        @Binding var showSuccess: Bool

        var body: some View {
            GeometryReader { g in
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("Unlock this plant species?")
                                .foregroundColor(Clr.black1)
                                .font(Font.mada(.bold, size: 24))
                                .lineLimit(1)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.vertical)
                            Text("Are you sure you want to spend \(userCoins) coins on unlocking \(userModel.willBuyPlant?.title ?? "")")
                                .font(Font.mada(.medium, size: 18))
                                .foregroundColor(Clr.black2.opacity(0.7))
                                .lineLimit(2)
                                .minimumScaleFactor(0.05)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            HStack(alignment: .center, spacing: -10) {
                                Button {
                                    Analytics.shared.log(event: .store_tapped_confirm_modal_cancel)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        shown = false
                                    }
                                } label: {
                                    Text("Cancel")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .frame(width: g.size.width/3, height: 40)
                                        .background(Color.gray)
                                }
                                Button {
                                    Analytics.shared.log(event: .store_tapped_confirm_modal_confirm)
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    userModel.buyPlant()
                                    withAnimation {
                                        shown = false
                                        showSuccess = true
                                    }
                                } label: {
                                    Text("Confirm")
                                        .font(Font.mada(.bold, size: 18))
                                        .foregroundColor(.white)
                                        .frame(width: g.size.width/3, height: 40)
                                        .background(Clr.darkgreen)
                                        .clipShape(Capsule())
                                        .neoShadow()
                                        .padding()
                                }
                            }.padding(.horizontal)
                        }.frame(width: g.size.width * 0.85, height: g.size.height * 0.30, alignment: .center)
                            .background(Clr.darkWhite)
                            .cornerRadius(20)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

}

struct Store_Previews: PreviewProvider {
    static var previews: some View {
        Store(showPlantSelect: .constant(false))
    }
}

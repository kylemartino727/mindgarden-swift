//
//  PlusMenu.swift
//  MindGarden
//
//  Created by Mark Jones on 6/28/21.
//

import SwiftUI

struct PlusMenu: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditateModel: MeditationViewModel
    @Binding var showPopUp: Bool
    @Binding var addMood: Bool
    @Binding var addGratitude: Bool

    ///Ashvin : Binding variable for pass animation flag
    @Binding var PopUpIn: Bool
    @Binding var showPopUpOption: Bool
    @Binding var showItems: Bool

    var isOnboarding: Bool

    let width: CGFloat
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if UserDefaults.standard.integer(forKey: "numMoods") >= 30 && !UserDefaults.standard.bool(forKey: "isPro") {
                        withAnimation {
                            Analytics.shared.log(event: .plus_tapped_mood_to_pricing)
                            fromPage = "plusMood"
                            viewRouter.currentPage = .pricing
                        }
                    } else {
                        Analytics.shared.log(event: .plus_tapped_mood)
                        withAnimation {

                            ///Ashvin : Hide popup with animation
                            hidePopupWithAnimation {
                                addMood = true
                            }
                        }
                    }
                } label: {
                    MenuChoice(title: "Mood Check", img: Image(systemName: "face.smiling"),  isOnboarding: false, disabled: isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp")
                        .frame(width: width/2.25, height: width/10.5)
                }.disabled(isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "signedUp")

                    ///Ashvin : Added property for animation
                    .animation(.easeIn(duration: 0.54))
                    .opacity(showItems ? 1 : 0)

                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if UserDefaults.standard.integer(forKey: "numGrads") >= 30 && !UserDefaults.standard.bool(forKey: "isPro") {
                        Analytics.shared.log(event: .plus_tapped_gratitude_to_pricing)
                        withAnimation {
                            fromPage = "plusGratitude"
                            viewRouter.currentPage = .pricing
                        }
                    } else {
                        Analytics.shared.log(event: .plus_tapped_gratitude)
                        if isOnboarding {
                            Analytics.shared.log(event: .onboarding_finished_meditation)
                        }
                        withAnimation {
                            ///Ashvin : Hide popup with animation
                            hidePopupWithAnimation {
                                addGratitude = true
                            }
                        }
                    }
                } label: {
                    MenuChoice(title: "Gratitude", img: Image(systemName: "square.and.pencil"), isOnboarding: isOnboarding, disabled: isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood")
                        .frame(width: width/2.25, height: width/10.5)
                }.disabled(isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "mood")

                    // Added property for animation
                    .animation(.easeIn(duration: 0.5))
                    .opacity(showItems ? 1 : 0)

                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if UserDefaults.standard.integer(forKey: "numMeds") >= 30 && !UserDefaults.standard.bool(forKey: "isPro") {
                        withAnimation {
                            fromPage = "plusMeditation"
                            viewRouter.currentPage = .pricing
                        }
                    } else {
                        Analytics.shared.log(event: .plus_tapped_meditate)
                        withAnimation {
                            // Hide popup with animation
                            hidePopupWithAnimation {
                                showPopUp = false
                            }
                        }

                        if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {
                            Analytics.shared.log(event: .onboarding_finished_gratitude)
                            meditateModel.selectedMeditation = Meditation.allMeditations.first(where: { med in
                                med.id == 22
                            })
                            viewRouter.currentPage = .play
                        } else {
                            if let defaultRecents = UserDefaults.standard.value(forKey: "recent") as? [Int] {
                                meditateModel.selectedMeditation = Meditation.allMeditations.filter({ med in defaultRecents.contains(med.id) }).reversed()[0]
                            } else {
                                meditateModel.selectedMeditation = meditateModel.featuredMeditation
                            }

                            if meditateModel.selectedMeditation?.type == .course {
                                viewRouter.currentPage = .middle
                            } else {
                                viewRouter.currentPage = .play
                            }
                        }
                    }
                } label: {
                    MenuChoice(title: "Meditate", img: Image(systemName: "play"),  isOnboarding: isOnboarding, disabled: isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude")
                        .frame(width: width/2.25, height: width/10.5)
                }.disabled(isOnboarding && UserDefaults.standard.string(forKey: K.defaults.onboarding) != "gratitude")
                    ///Ashvin : Added property for animation
                    .animation(.easeIn(duration: 0.5))
                    .opacity(showItems ? 1 : 0)
            }
        }
        ///Ashvin : Change the frame while animation
        .frame(width: PopUpIn ? width/2 : width/7, height: showPopUpOption ? width/2.25 : PopUpIn ? width/3.25: width/5)
        .transition(.scale)
        .background(Clr.superWhite)
        .cornerRadius(18)
        .zIndex(-10)
        .padding(.bottom, 10)

    }

    ///Ashvin : Hide popup with animation method

    private func hidePopupWithAnimation(completion: @escaping () -> ()) {
        withAnimation(.easeOut(duration: 0.2)) {
            showItems = false
        }
        withAnimation(.easeOut(duration: 0.14).delay(0.1)) {
            showPopUpOption = false
        }
        withAnimation(.easeOut(duration: 0.08).delay(0.24)) {
            PopUpIn = false
        }
        withAnimation(.easeOut(duration: 0.14).delay(0.31)){
            showPopUp = false
            completion()
        }
    }

    struct MenuChoice: View {
        let title: String
        let img: Image
        let isOnboarding: Bool
        let disabled: Bool

        var body: some View {
            ZStack {
                Capsule()
                    .fill(Clr.darkWhite)
                HStack {
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Clr.darkgreen)
                        .padding(3)
                    Text(title)
                        .font(Font.mada(.medium, size: 20))
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Clr.darkgreen)
                        .frame(width: UIScreen.main.bounds.width * 0.3)
                        .multilineTextAlignment(.trailing)
                }.frame(width: UIScreen.main.bounds.width * 0.4, alignment: .leading)
                .padding(5)
            }
            .opacity(disabled ? 0.3 : 1)
            .neoShadow()
        }
    }
}

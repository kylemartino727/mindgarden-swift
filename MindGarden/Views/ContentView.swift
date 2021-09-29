//
//  ContentView.swift
//  MindGarden
//
//  Created by Mark Jones on 5/25/21.
//

import SwiftUI
import Combine
import Lottie

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var userModel: UserViewModel
    @EnvironmentObject var gardenModel: GardenViewModel
    @State private var showPopUp = false
    @State private var addMood = false
    @State private var openPrompts = false
    @State private var addGratitude = false
    @State private var isOnboarding = false
    @State private var isKeyboardVisible = false
    @State private var animateSplash = false
    @State private var showSplash = true
    @State private var animationAmount: CGFloat = 1
    ///Ashvin : State variable for pass animation flag
    @State private var PopUpIn = false
    @State private var showPopUpOption = false
    @State private var showItems = false

    var bonusModel: BonusViewModel
    var profileModel: ProfileViewModel
    var authModel: AuthenticationViewModel

    init(bonusModel: BonusViewModel, profileModel: ProfileViewModel, authModel: AuthenticationViewModel) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        self.bonusModel = bonusModel
        self.profileModel = profileModel
        self.authModel = authModel
        //        meditationModel.isOpenEnded = false
        //        meditationModel.secondsRemaining = 150
        // check for auth here
    }

    var body: some View {
        VStack {
            ZStack {
                // Content
                ZStack {
                    GeometryReader { geometry in
                        ZStack {
                            Clr.darkWhite.edgesIgnoringSafeArea(.all)
                            VStack {
                                if #available(iOS 14.0, *) {
                                    switch viewRouter.currentPage {
                                    case .onboarding:
                                            OnboardingScene()
                                                .frame(height: geometry.size.height)
                                                .navigationViewStyle(StackNavigationViewStyle())
                                    case .experience:
                                            ExperienceScene()
                                                .frame(height: geometry.size.height)
                                                .navigationViewStyle(StackNavigationViewStyle())
                                    case .meditate:
                                        Home(bonusModel: bonusModel)
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .onAppear {
                                                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "signedUp" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "mood" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {

                                                    showPopupWithAnimation {
                                                        self.isOnboarding = true
                                                    }
                                                }
                                            }
                                            .disabled(isOnboarding)
                                    case .garden:
                                        Garden()
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .onAppear {
                                                    showPopUpOption = false
                                                    showPopUp = false
                                                    showItems = false
                                            }
                                    case .shop:
                                        Store(showPlantSelect: .constant(false))
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .environmentObject(bonusModel)
                                    case .profile:
                                        ProfileScene(profileModel: profileModel )
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .categories:
                                        CategoriesScene(showSearch: .constant(false))
                                            .frame(height: geometry.size.height)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .middle:
                                        MiddleSelect()
                                            .frame(height: geometry.size.height + 10)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .play:
                                        Play()
                                            .frame(height: geometry.size.height + 80)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                            .onAppear {
                                                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "gratitude" {

                                                    showPopupWithAnimation {
                                                        self.isOnboarding = false
                                                    }
                                                }
                                            }
                                    case .finished:
                                        Finished(model: meditationModel, userModel: userModel, gardenModel: gardenModel)
                                            .frame(height: geometry.size.height)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .authentication:
                                        Authentication(isSignUp: !tappedSignIn, viewModel: authModel)
                                            .frame(height: geometry.size.height)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .notification:
                                        NotificationScene()
                                            .frame(height: geometry.size.height)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .name:
                                        NameScene()
                                            .frame(height: geometry.size.height)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .pricing:
                                        PricingView()
                                            .frame(height: geometry.size.height + 80)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .reason:
                                        ReasonScene()
                                            .frame(height: geometry.size.height)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    case .review:
                                        ReviewScene()
                                            .frame(height: geometry.size.height)
                                            .navigationViewStyle(StackNavigationViewStyle())
                                    }

                                } else {
                                    // Fallback on earlier versions
                                }
                                if viewRouter.currentPage == .notification || viewRouter.currentPage == .onboarding
                                                || viewRouter.currentPage == .experience || viewRouter.currentPage == .name  || viewRouter.currentPage == .reason || viewRouter.currentPage == .review {
                                    ZStack(alignment: .leading) {
                                        Rectangle().frame(width: geometry.size.width - 50 , height: 20)
                                            .opacity(0.3)
                                            .foregroundColor(Clr.darkWhite)
                                        Rectangle().frame(width: min(CGFloat(viewRouter.progressValue) * (geometry.size.width - 50), geometry.size.width - 50), height: 20)
                                            .foregroundColor(Clr.brightGreen)
                                            .animation(.linear)
                                            .neoShadow()
                                    }.cornerRadius(45.0)
                                        .padding()
                                        .neoShadow()
                                }
                            }.edgesIgnoringSafeArea(.all)
                            if viewRouter.currentPage != .play && viewRouter.currentPage != .authentication
                                && viewRouter.currentPage != .notification && viewRouter.currentPage != .onboarding
                                && viewRouter.currentPage != .experience && viewRouter.currentPage != .finished && viewRouter.currentPage != .name  && viewRouter.currentPage != .pricing  && viewRouter.currentPage != .reason && viewRouter.currentPage != .review {
                                ///Ashvin : Replace background button to stack with shollw effect with animation
                                ZStack {
                                    Rectangle()
                                        .opacity(showPopUp || addMood || addGratitude || isOnboarding ? 0.3 : 0.0)
                                        .foregroundColor(Clr.black1)
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(height: geometry.size.height + 10)
                                        .transition(.opacity)
                                }
                                .onTapGesture {
                                    if !isOnboarding {
                                        withAnimation {
                                            hidePopupWithAnimation {
                                                addMood = false
                                                addGratitude = false
                                            }
                                        }
                                    }
                                }
                                ZStack {
                                    ///Ashvin : Pass the required flag and change offset while animation
                                    PlusMenu(showPopUp: $showPopUp, addMood: $addMood, addGratitude: $addGratitude, PopUpIn: $PopUpIn, showPopUpOption: $showPopUpOption, showItems: $showItems, isOnboarding: isOnboarding, width: geometry.size.width)
                                        .offset(y: showPopUp ? (showPopUpOption ? (geometry.size.height/2.01 - (K.hasNotch() ? 125 : K.isPad() ? geometry.size.height : geometry.size.height/5)) : (PopUpIn ? (geometry.size.height/1.88 - (K.hasNotch() ? 125 : K.isPad() ? geometry.size.height : geometry.size.height/5)) : (geometry.size.height/1.75 - (K.hasNotch() ? 125 : K.isPad() ? geometry.size.height : geometry.size.height/5)))) : geometry.size.height/2 + 60)

                                    //The way user defaults work is that each step, should be the previous steps title. For example if we're on the mood check step,
                                    //onboarding userdefault should be equal to signedUp because we just completed it.
                                    if UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "signedUp" || UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "mood" ||  UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "gratitude"   {
                                        LottieView(fileName: "side-arrow")
                                            .frame(width: 75, height: 25)
                                            .padding(.horizontal)
                                            .offset(x: -20, y: UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "signedUp" ? geometry.size.height * (K.hasNotch()  ? -0.025 : -0.125) : UserDefaults.standard.string(forKey: K.defaults.onboarding) ?? "" == "gratitude" ? geometry.size.height * (K.hasNotch()  ? 0.1 : 0.025) : geometry.size.height * (K.hasNotch()  ? 0.03 : -0.045))
                                    }
                                    HStack {
                                        TabBarIcon(viewRouter: viewRouter, assignedPage: .garden, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Garden", img: Img.plantIcon)
                                        TabBarIcon(viewRouter: viewRouter, assignedPage: .meditate, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Meditate", img: Img.meditateIcon)
                                        ZStack {
                                            Rectangle()
                                                .cornerRadius(18, corners: showPopUp ? [.bottomLeft, .bottomRight] : [.topRight, .topLeft, .bottomLeft, .bottomRight])
                                                .foregroundColor(Clr.superWhite)
                                                .frame(maxWidth: geometry.size.width/7, maxHeight: geometry.size.width/7)
                                                .shadow(color: showPopUp ? .black.opacity(0) : .black.opacity(0.25), radius: 4, x: 4, y: 4)
                                                .zIndex(1)

                                            Image(systemName: "plus")
                                                .foregroundColor(Clr.darkgreen)
                                                .font(Font.title.weight(.semibold))
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxWidth: geometry.size.width/5.5-6 , maxHeight: geometry.size.width/5.5-6)
                                                .zIndex(2)
                                                .rotationEffect(showPopUp ? .degrees(45) : .degrees(0))
                                        }
                                        .onTapGesture {
                                            if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "done"  && viewRouter.currentPage == .garden {} else {
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                ///Ashvin : Hide & Show popup with animation
                                                if showPopUp == false {
                                                    showPopupWithAnimation {}
                                                }
                                                else {
                                                    hidePopupWithAnimation {}
                                                }
                                            }
                                        }
                                        .offset(y: -geometry.size.height/18/2)
                                        TabBarIcon(viewRouter: viewRouter, assignedPage: .shop, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Shop", img: Img.shopIcon)
                                        TabBarIcon(viewRouter: viewRouter, assignedPage: .profile, width: geometry.size.width/5, height: geometry.size.height/40, tabName: "Profile", img: Img.profileIcon)
                                    }.frame(width: geometry.size.width, height: 80)
                                        .background(Clr.darkgreen.shadow(radius: 2))
                                        .offset(y: geometry.size.height/2 - (K.isPad() ? 25 : (K.hasNotch() ? 0 : 15)))
                                }
                                MoodCheck(shown: $addMood, showPopUp: $showPopUp, PopUpIn: $PopUpIn, showPopUpOption: $showPopUpOption, showItems: $showItems)
                                    .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                                    .background(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .offset(y: addMood ? geometry.size.height/(K.hasNotch() ? 2.5 : 2.75) : geometry.size.height)
                                Gratitude(shown: $addGratitude, showPopUp: $showPopUp, openPrompts: $openPrompts, contentKeyVisible: $isKeyboardVisible, PopUpIn: $PopUpIn, showPopUpOption: $showPopUpOption, showItems: $showItems)
                                    .frame(width: geometry.size.width, height: (geometry.size.height * (K.hasNotch() ? 0.5 : 0.6 ) * (openPrompts ? 2.25 : 1)) + (isKeyboardVisible ? geometry.size.height * 0.2 : 0))
                                    .background(Clr.darkWhite)
                                    .cornerRadius(12)
                                    .offset(y: (addGratitude ? geometry.size.height/(K.hasNotch()
                                                                                     ? 3.25 * (openPrompts ? 2 : 1)
                                                                                     : K.isPad()  ?  2.5 * (openPrompts ? 2 : 1)
                                                                                     : 4.5 * (openPrompts ? 3.5 : 1) )
                                                : geometry.size.height) - (isKeyboardVisible ? geometry.size.height * 0.12 : 0))
                            }
                        }
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarHidden(true)
                    }.navigationViewStyle(StackNavigationViewStyle())
                }

                // Splash
                ZStack {
                    Clr.darkWhite
                    VStack {
                        Img.coloredPots
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .scaleEffect(animationAmount)
                            .opacity(Double(2 - animationAmount))
                            .animation(
                                Animation.easeOut(duration: 2.0)
                            )
                    }
                }.edgesIgnoringSafeArea(.all)
                    .animation(.default, value: showSplash)
                    .opacity(showSplash ? 1 : 0)
            }
        }.onAppear {
            animationAmount = 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSplash.toggle()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.gratitude))
               { _ in addGratitude = true }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.mood))
                      { _ in addMood = true }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.pro))
        { _ in
            fromPage = "widget"
            viewRouter.currentPage = .pricing}
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.meditate))
        { _ in
            print("f")
            if let defaultRecents = UserDefaults.standard.value(forKey: "recent") as? [Int] {
                meditationModel.selectedMeditation = Meditation.allMeditations.filter({ med in defaultRecents.contains(med.id) }).reversed()[0]
            } else {
                meditationModel.selectedMeditation = meditationModel.featuredMeditation
            }

            if meditationModel.selectedMeditation?.type == .course {
                viewRouter.currentPage = .middle
            } else {
                viewRouter.currentPage = .play
            }
        }

    }
    func openedGratitude() {
        addGratitude = true
    }
    ///Ashvin : Show popup with animation method

    public func showPopupWithAnimation(completion: @escaping () -> ()) {
        withAnimation(.easeIn(duration:0.14)){
            showPopUp = true
        }
        withAnimation(.easeIn(duration: 0.08).delay(0.14)) {
            PopUpIn = true
        }
        withAnimation(.easeIn(duration: 0.14).delay(0.22)) {
            showPopUpOption = true
        }
        withAnimation(.easeIn(duration: 0.4).delay(0.36)) {
            showItems = true
            completion()
        }
    }

    ///Ashvin : Hide popup with animation method

    public func hidePopupWithAnimation(completion: @escaping () -> ()) {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(bonusModel: BonusViewModel(userModel: UserViewModel()), profileModel: ProfileViewModel(), authModel: AuthenticationViewModel(userModel: UserViewModel(), viewRouter: ViewRouter()))
    }
}

extension NSNotification {
    static let gratitude = Notification.Name.init("gratitude")
    static let meditate = Notification.Name.init("meditate")
    static let mood = Notification.Name.init("mood")
    static let pro = Notification.Name.init("pro")
}

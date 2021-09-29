//
//  NotificationScene.swift
//  MindGarden
//
//  Created by Mark Jones on 9/5/21.
//

import SwiftUI

struct NotificationScene: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var dateTime = Date()
    @State private var frequency = "Everyday"
    @State private var bottomSheetShown = false
    @State private var showAlert = false
    @State private var showActionSheet = false
    var fromSettings: Bool

    var displayedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: dateTime)
    }

    init(fromSettings: Bool = false) {
        self.fromSettings = fromSettings
        //        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        ZStack {
            GeometryReader { g in
                let width = g.size.width
                ZStack {
                    Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                    VStack(spacing: -5) {
                        HStack {
                            Img.topBranch.padding(.leading, -20)
                            Spacer()
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 22))
                                .foregroundColor(Clr.darkgreen)
                                .padding()
                                .onTapGesture {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation {
                                        if fromSettings {
                                            presentationMode.wrappedValue.dismiss()
                                        } else if tappedTurnOn {
                                            viewRouter.currentPage = .review
                                            tappedTurnOn = false
                                        } else {
                                            viewRouter.currentPage = .reason
                                        }
                                    }
                                }
                                .opacity(fromSettings ? 0 : 1)
                                .disabled(fromSettings)
                        }
                        VStack {
                            Text("🔔 Set a Reminder")
                                .font(Font.mada(.semiBold, size: 28))
                                .foregroundColor(Clr.black1)
                                .multilineTextAlignment(.center)
                            Text("You're 74% more likely to stick with meditation if you set a reminder. ")
                                .font(Font.mada(.bold, size: 22))
                                .foregroundColor(Clr.darkgreen)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    bottomSheetShown.toggle()
                                }
                            } label: {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .cornerRadius(12)
                                    .frame(width: width * 0.6, height: 75)
                                    .overlay(
                                        HStack {
                                            Text("\(displayedTime)")
                                                .font(Font.mada(.bold, size: 40))
                                                .foregroundColor(.black)
                                            Image(systemName: "chevron.down")
                                                .font(Font.title)
                                        }
                                    )
                            }.buttonStyle(NeumorphicPress())
                                .padding()
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                showActionSheet = true
                            } label: {
                                Rectangle()
                                    .fill(Clr.yellow)
                                    .cornerRadius(12)
                                    .frame(width: width * 0.6, height: 50)
                                    .overlay(
                                        HStack {
                                            Text("\(frequency)")
                                                .font(Font.mada(.bold, size: 26))
                                                .foregroundColor(.black)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .font(Font.title)
                                        }.padding(.horizontal)
                                    )
                            }.buttonStyle(NeumorphicPress())
                            Spacer()
                            Img.eggs
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .neoShadow()
                                .frame(width: g.size.width * 0.35)
                            Spacer()
                         
                            Button {
                                Analytics.shared.log(event: .notification_tapped_turn_on)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    let current = UNUserNotificationCenter.current()
                                            current.getNotificationSettings(completionHandler: { permission in
                                                switch permission.authorizationStatus  {
                                                case .authorized:
                                                    UserDefaults.standard.setValue(dateTime, forKey: K.defaults.meditationReminder)
                                                    Analytics.shared.log(event: .notification_success)
                                                    if UserDefaults.standard.value(forKey: "oneDayNotif") == nil {
                                                        NotificationHelper.addOneDay()
                                                    }
                                                    if UserDefaults.standard.value(forKey: "threeDayNotif") == nil {
                                                        NotificationHelper.addThreeDay()
                                                    }
                                                    UserDefaults.standard.setValue(dateTime, forKey: "notif")
                                                    UserDefaults.standard.setValue(true, forKey: "notifOn")

                                                    if frequency == "Everyday" {
                                                        for i in 1...7 {
                                                            let datee = NotificationHelper.createDate(weekday: i, hour: Int(dateTime.get(.hour))!, minute: Int(dateTime.get(.minute))!)
                                                            NotificationHelper.scheduleNotification(at: datee,  weekDay: i)
                                                        }
                                                    } else if frequency == "Weekdays" {
                                                        for i in 2...6 {
                                                            NotificationHelper.scheduleNotification(at: NotificationHelper.createDate(weekday: i, hour: Int(dateTime.get(.hour))!, minute: Int(dateTime.get(.minute))!), weekDay: i)
                                                        }
                                                    } else { // weekend
                                                        NotificationHelper.scheduleNotification(at: NotificationHelper.createDate(weekday: 1, hour: Int(dateTime.get(.hour))!, minute: Int(dateTime.get(.minute))!), weekDay: 1)
                                                        NotificationHelper.scheduleNotification(at: NotificationHelper.createDate(weekday: 7, hour: Int(dateTime.get(.hour))!, minute: Int(dateTime.get(.minute))!), weekDay: 7)
                                                    }


                                                    DispatchQueue.main.async {
                                                        if fromSettings {
                                                            presentationMode.wrappedValue.dismiss()
                                                        } else {
                                                            if tappedTurnOn {
                                                                viewRouter.currentPage = .review
                                                            } else {
                                                                viewRouter.progressValue += 0.1
                                                                viewRouter.currentPage = .name
                                                            }
                                                        }
                                                        
                                                    }
                                                case .denied:
                                                    Analytics.shared.log(event: .notification_go_to_settings)
                                                    DispatchQueue.main.async {
                                                        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                                                            UIApplication.shared.open(appSettings)
                                                        }
                                                    }
                                                case .notDetermined:
                                                    Analytics.shared.log(event: .notification_go_to_settings)
                                                    DispatchQueue.main.async {
                                                        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                                                            UIApplication.shared.open(appSettings)
                                                        }
                                                    }
                                                default:
                                                    print("Unknow Status")
                                                }
                                            })
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.darkWhite)
                                    .overlay(
                                        Text(fromSettings ? "Turn On" : "Continue")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.bold, size: 20))
                                    )
                            }.frame(height: 50)
                                .padding()
                                .buttonStyle(NeumorphicPress())
                            if !fromSettings {
                                Text("Skip")
                                    .foregroundColor(.gray)
                                    .padding()
                                    .onTapGesture {
                                        Analytics.shared.log(event: .notification_tapped_skip)
                                        withAnimation {
                                            withAnimation {
                                                if tappedTurnOn {
                                                    viewRouter.currentPage = .review
                                                } else {
                                                    viewRouter.progressValue += 0.1
                                                    viewRouter.currentPage = .name
                                                }
                                            }
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        }
                                    }
                            }
                        }.frame(width: width * 0.9)
                        .padding(.top, 20)
                    }

                    if bottomSheetShown  {
                        Color.black
                            .opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                        Spacer()
                    }
                }
                BottomSheetView(
                    dateSelected: $dateTime,
                    isOpen: self.$bottomSheetShown,
                    maxHeight: g.size.height * 0.6
                ) {
                    DatePicker("", selection: $dateTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .offset(y: -25)
                }.offset(y: g.size.height * 0.3)
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Frequency"),
                            buttons: [
                                .default(
                                    Text("Everyday"),
                                    action: {
                                        frequency = "Everyday"
                                        showActionSheet = false
                                    }
                                ),
                                .default(
                                    Text("On Weekends"),
                                    action: {
                                        frequency = "Weekends"
                                        showActionSheet = false
                                    }
                                ),
                                .default(
                                    Text("On Weekdays"),
                                    action: {
                                        frequency = "Weekdays"
                                        showActionSheet = false
                                    }
                                )
                            ]
                )
            }
        .transition(.move(edge: .trailing))
        .onAppearAnalytics(event: .screen_load_notification)
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Turn on Notifications"), message: Text("We'll do our best not to annoy you"), dismissButton: .default(Text("Go to Settings"), action: {
//                    if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
//                        UIApplication.shared.open(appSettings)
//                    }
//                    showAlert = false
//                }))
//            }

    }
}



struct NotificationScene_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScene()
    }
}

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetView<Content: View>: View {
    @GestureState private var translation: CGFloat = 0
    @Binding var dateSelected: Date
    @Binding var isOpen: Bool
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        HStack {
            Text("Done").padding().foregroundColor(Clr.darkWhite)
            Spacer()
            RoundedRectangle(cornerRadius: Constants.radius)
                .fill(Color.secondary)
                .frame(
                    width: Constants.indicatorWidth,
                    height: Constants.indicatorHeight
                )
            Spacer()
            Text("Done")
                .font(Font.mada(.bold, size: 18))
                .foregroundColor(Clr.darkgreen)
                .onTapGesture {
                    Analytics.shared.log(event: .notification_tapped_done)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self.isOpen.toggle()
                }
                .padding(.horizontal)
        }
    }

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    init(dateSelected: Binding<Date>, isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        self._dateSelected = dateSelected
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else { return }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}

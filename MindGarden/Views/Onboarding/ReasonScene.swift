//
//  ExperienceScene.swift
//  MindGarden
//
//  Created by Mark Jones on 9/5/21.
//

import SwiftUI
//TODO fix navigation bar items not appearing in ios 15 phones
struct ReasonScene: View {
    @State var selected: String = ""
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var meditationModel: MeditationViewModel
    @EnvironmentObject var gardenModel: GardenViewModel

    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        VStack {
                GeometryReader { g in
                    let width = g.size.width
                    let height = g.size.height
                    ZStack {
                        Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                        VStack {
                            HStack {
                                Img.topBranch.padding(.leading, -20)
                                Spacer()
                            }
                            Text("What brings you to MindGarden?")
                                .font(Font.mada(.bold, size: 24))
                                .foregroundColor(Clr.darkgreen)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)
                                .padding(.horizontal)
                            SelectionRow(width: width, height: height, title: "Sleep better", img: Img.moon, selected: $selected)
                            SelectionRow(width: width, height: height, title: "Get more focused", img: Img.target, selected: $selected)
                            SelectionRow(width: width, height: height, title: "Managing Stress & Anxiety", img: Img.heart, selected: $selected)
                            Button {
                                Analytics.shared.log(event: .experience_tapped_continue)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                if selected != "" {
                                    switch selected {
                                    case "Sleep better":
                                        Analytics.shared.log(event: .reason_tapped_sleep)
                                    case "Get more focused":
                                        Analytics.shared.log(event: .reason_tapped_focus)
                                    case "Managing Stress & Anxiety":
                                        Analytics.shared.log(event: .reason_tapped_stress)
                                    default:
                                        break
                                    }
                                    withAnimation {
                                        viewRouter.progressValue += 0.1
                                        viewRouter.currentPage = .notification
                                    }
                                } //TODO gray out button if not selected
                            } label: {
                                Capsule()
                                    .fill(Clr.darkWhite)
                                    .overlay(
                                        Text("Continue")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.bold, size: 20))
                                    )
                            }.frame(height: 50)
                                .padding()
                                .buttonStyle(NeumorphicPress())
                            Spacer()
                        }
                }
            }
        }.onDisappear {
            meditationModel.getFeaturedMeditation()
        }
        .onAppearAnalytics(event: .screen_load_reason)
        .transition(.move(edge: .trailing))
    }

    struct SelectionRow: View {
        var width, height: CGFloat
        var title: String
        var img: Image
        @Binding var selected: String

        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    selected = title
                    UserDefaults.standard.setValue(title, forKey: "reason")
                }
            } label: {
                ZStack {
                    Rectangle()
                        .fill(selected == title ? Clr.yellow : Clr.darkWhite)
                        .cornerRadius(15)
                        .frame(height: height * 0.15)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                                    .stroke(Clr.darkgreen, lineWidth: selected == title ? 3 : 0))
                        .padding(.horizontal)
                        .padding(.vertical, 8)

                    HStack(spacing: 50) {
                        Text(title)
                            .font(Font.mada(.bold, size: 24))
                            .foregroundColor(Clr.black1)
                            .padding()
                            .frame(width: width * 0.5, alignment: .leading)
                        img
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width * 0.15)
                    }
                }
            }.buttonStyle(NeumorphicPress())
        }
    }
}

struct ReasonScene_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceScene()
    }
}

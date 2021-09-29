//
//  TabBarIcon.swift
//  MindGarden
//
//  Created by Mark Jones on 6/6/21.
//

import SwiftUI

struct TabBarIcon: View {
    @ObservedObject var viewRouter: ViewRouter
    @State private var isSelected: Bool = false
    let assignedPage: Page
    let width, height: CGFloat
    let tabName: String
    let img: Image

    var body: some View {
        let isCategory = viewRouter.currentPage == .categories && tabName == "Meditate"
        VStack {
            img
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            if viewRouter.currentPage == assignedPage || isCategory {
                withAnimation {
                    Rectangle().frame(width: width/2, height: height/8).foregroundColor(.white)
                        .padding(.top, 5)
                }
            }
            Spacer()
        }.padding(.horizontal, -5)
        .padding(.top, 10)
        .foregroundColor(viewRouter.currentPage == assignedPage || isCategory ? .white : Clr.unselectedIcon)
        .onTapGesture {
            Analytics.shared.log(event: AnalyticEvent.getTab(tabName: tabName))
            withAnimation {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                if UserDefaults.standard.string(forKey: K.defaults.onboarding) == "done" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "stats" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "calendar" || UserDefaults.standard.string(forKey: K.defaults.onboarding) == "single"  {
                    viewRouter.currentPage = assignedPage
                }
            }
        }
    }
}
struct TabBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        TabBarIcon(viewRouter: ViewRouter(), assignedPage: .shop, width: 0, height: 0, tabName: "bing", img: Img.shopIcon).environmentObject(ViewRouter())
    }
}

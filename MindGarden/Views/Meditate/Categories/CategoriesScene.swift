//
//  CategoriesScene.swift
//  MindGarden
//
//  Created by Mark Jones on 7/14/21.
//

import SwiftUI
import Combine

@available(iOS 14.0, *)
struct CategoriesScene: View {
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: -20), count: 2)
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var model: MeditationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var searchText: String = ""
    var isSearch: Bool = false
    @Binding var showSearch: Bool
    @State var tappedMed = false

    init(isSearch: Bool = false, showSearch: Binding<Bool>) {
        self.isSearch = isSearch
        self._showSearch = showSearch
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
            GeometryReader { g in
                ZStack {
                Clr.darkWhite.edgesIgnoringSafeArea(.all).animation(nil)
                VStack(alignment: .center) {
                    if !isSearch {
                        HStack {
                            backButton
                            Spacer()
                            Text("Categories")
                                .foregroundColor(Clr.black2)
                                .font(Font.mada(.bold, size: 20))
                            Spacer()
                                backButton
                                    .opacity(0)
                                    .disabled(true)
                        }.padding([.top, .horizontal])
                    }

                    if isSearch {
                        //Search bar
                        HStack {
                            backButton.padding()
                                HStack {
                                    TextField("Search...", text: $searchText) { startedEditing in
                                        if startedEditing {

                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "magnifyingglass")
                                }
                                .padding()
                                .foregroundColor(.gray)
                                .frame(height: 40)
                                .cornerRadius(13)
                                .background(Clr.darkWhite)
                                .padding(.trailing)
                                .neoShadow()
                        }.padding(.top)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        if !isSearch {
                            HStack {
                                CategoryButton(category: .all, selected: $model.selectedCategory)
                                CategoryButton(category: .unguided, selected: $model.selectedCategory)
                                CategoryButton(category: .beginners, selected: $model.selectedCategory)
                                CategoryButton(category: .anxiety, selected: $model.selectedCategory)
                                CategoryButton(category: .focus, selected: $model.selectedCategory)
                                CategoryButton(category: .growth, selected: $model.selectedCategory)
                                CategoryButton(category: .sleep, selected: $model.selectedCategory)
                                CategoryButton(category: .courses, selected: $model.selectedCategory)
                            }.padding([.horizontal, .bottom])
                        }
                    }
                    ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: gridItemLayout, content: {
                                ForEach(!isSearch ? model.selectedMeditations : model.selectedMeditations.filter({ (meditation: Meditation) -> Bool in
                                    return meditation.title.hasPrefix(searchText) || searchText == ""
                                }), id: \.self) { item in
                                    HomeSquare(width: UIScreen.main.bounds.width / (K.isPad() ? 1.4 : 1), height: (UIScreen.main.bounds.height * 0.75) , img: item.img, title: item.title, id: item.id, description: item.description, duration: item.duration)
                                        .onTapGesture {
                                            withAnimation {
                                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                                if !UserDefaults.standard.bool(forKey: "isPro") && Meditation.lockedMeditations.contains(item.id) {
                                                    fromPage = "lockedMeditation"
                                                    Analytics.shared.log(event: .categories_tapped_locked_meditation)
                                                    viewRouter.currentPage = .pricing
                                                } else {
                                                    Analytics.shared.log(event: .categories_tapped_meditation)
                                                    model.selectedMeditation = item
                                                    if isSearch {
                                                        tappedMed = true
                                                        presentationMode.wrappedValue.dismiss()
                                                    } else {
                                                        if model.selectedMeditation?.type == .course {
                                                            viewRouter.currentPage = .middle
                                                        } else {
                                                            viewRouter.currentPage = .play
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .neoShadow()
                                        .padding(.vertical, 8)
                                }
                            })
                    }
                    Spacer()
                }
                .background(Clr.darkWhite)
                }
            }
        .transition(.move(edge: .bottom))
        .onAppear {
            model.selectedCategory = .all

        }
        .gesture(DragGesture()
                     .onChanged({ _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                     })
         )
        .onDisappear {
            if tappedMed {
                if model.selectedMeditation?.type == .course {
                    viewRouter.currentPage = .middle
                } else {
                    viewRouter.currentPage = .play
                }
            }
        }
        .onAppearAnalytics(event: .screen_load_categories)
    }

    var backButton: some View {
        Button {
            if isSearch {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                self.presentationMode.wrappedValue.dismiss()
            } else {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    viewRouter.currentPage = .meditate
                }
            }
        } label: {
            Image(systemName: "arrow.backward")
                .foregroundColor(Clr.darkgreen)
                .font(.system(size: 22))
                .padding(.leading, 10)
        }
    }

    var searchButton: some View {
        Button {
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22))
                .foregroundColor(Clr.darkgreen)
        }
    }

    struct CategoryButton: View {
        var category: Category
        @Binding var selected: Category?

        var body: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                Analytics.shared.log(event: AnalyticEvent.getCategory(category: category.value))
                withAnimation {
                    selected = category
                }
            } label: {
                HStack {
                    Text(category.value)
                        .font(Font.mada(selected == category ? .bold : .regular, size: 16))
                        .foregroundColor(selected == category ? .black : Clr.black2)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                .padding(8)
                .background(selected == category ? Clr.yellow : Clr.darkWhite)
                .cornerRadius(25)
            }
            .buttonStyle(NeumorphicPress())
            .padding(0)
        }
    }
}

enum Category {
    case all
    case unguided
    case courses
    case beginners
    case anxiety
    case focus
    case confidence
    case growth
    case sleep

    var value: String {
        switch self {
        case .all:
            return "All"
        case .unguided:
            return "Unguided"
        case .beginners:
            return "Beginners"
        case .courses:
            return "Courses"
        case .anxiety:
            return "Anxiety"
        case .focus:
            return "Focus"
        case .sleep:
            return "Sleep"
        case .confidence:
            return "Confidence"
        case .growth:
            return "Growth"
        }
    }
}

struct CategoriesScene_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            CategoriesScene(showSearch: .constant(false))
        }
    }
}

extension ScrollView {
    private typealias PaddedContent = ModifiedContent<Content, _PaddingLayout>

    func fixFlickering() -> some View {
        GeometryReader { geo in
            ScrollView<PaddedContent>(axes, showsIndicators: showsIndicators) {
                content.padding(geo.safeAreaInsets) as! PaddedContent
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

//
//  NameScene.swift
//  MindGarden
//
//  Created by Mark Jones on 9/23/21.
//

import SwiftUI

struct NameScene: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var name: String = ""
    @State var isFirstResponder = true
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
                                            viewRouter.currentPage = .notification
                                        }
                                    }
                                
                            }
                            Spacer()
                            HStack {
                                Img.sheep
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                                    .padding(.trailing, 15)
                                    .neoShadow()
                                VStack {
                                    Text("What's your name?")
                                        .font(Font.mada(.bold, size: 26))
                                        .foregroundColor(Clr.darkgreen)
                                        .multilineTextAlignment(.center)
                                        .frame(width: width * 0.6, height: 60)
                                    LegacyTextField(text: $name, isFirstResponder: $isFirstResponder)
                                        .padding(15)
                                        .background(
                                            Rectangle()
                                                .foregroundColor(Clr.darkWhite)
                                                .cornerRadius(14)
                                        )
                                        .frame(width: width * 0.6, height: 60)
                                        .neoShadow()
                                        .disableAutocorrection(true)
                                }
                            }.frame(height: 80)
                            Spacer()
                            Button {
                                Analytics.shared.log(event: .name_tapped_continue)
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation {
                                    if !name.isEmpty {
                                        UserDefaults.standard.set(name, forKey: "name")
                                        viewRouter.progressValue += 0.1
                                        viewRouter.currentPage = .review
                                    }
                                }
                            } label: {
                                Capsule()
                                    .fill(Clr.yellow)
                                    .overlay(
                                        Text("Continue")
                                            .foregroundColor(Clr.darkgreen)
                                            .font(Font.mada(.bold, size: 20))
                                    )
                            }.frame(height: 50)
                                .padding()
                                .buttonStyle(NeumorphicPress())
                        }.frame(width: width * 0.9)
                            .padding(.bottom, g.size.height * 0.15)
                    }
                }
                .onAppearAnalytics(event: .screen_load_name)
        }.transition(.move(edge: .trailing))
    }
}

struct NameScene_Previews: PreviewProvider {
    static var previews: some View {
        NameScene()
    }
}

import UIKit
struct LegacyTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String

    public var configuration = { (view: UITextField) in }

    public init(text: Binding<String>, isFirstResponder: Binding<Bool>, configuration: @escaping (UITextField) -> () = { _ in }) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder
    }

    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        switch isFirstResponder {
        case true: uiView.becomeFirstResponder()
        case false: uiView.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>

        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }

        @objc public func textViewDidChange(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
    }
}

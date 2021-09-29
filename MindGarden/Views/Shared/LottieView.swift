//
//  LottieView.swift
//  MindGarden
//
//  Created by Mark Jones on 9/11/21.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    var fileName: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

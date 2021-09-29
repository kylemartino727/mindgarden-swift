//
//  ButtonStyle.swift
//  Lottery.com
//
//

import SwiftUI

struct NeumorphicPress: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98: 1)
            .animation(.easeOut(duration: 0.1))
            .shadow(color:  colorScheme == .light ? Clr.shadow.opacity(0.3) : Clr.darkShadow.opacity(0.95), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
            .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Clr.blackShadow.opacity(0.4), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
    }
}


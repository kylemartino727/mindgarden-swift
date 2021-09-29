//
//  Widget+Extensions.swift
//  MindGardenWidgetExtension
//
//  Created by Mark Jones on 12/27/21.
//

import SwiftUI

struct ShadowViewModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func body(content: Content) -> some View {
        content
            .shadow(color: colorScheme == .light ? Color("shadow").opacity(0.3) : Color("darkShadow").opacity(0.95), radius: 5 , x: 5, y: 5)
            .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Color("blackShadow").opacity(0.4), radius: 5, x: -5, y: -5)
    }
}

extension View {
    /// Adds a shadow onto this view with the specified `ShadowStyle`
    func neoShadow() -> some View {
        self.modifier(ShadowViewModifier())
    }
}

struct NeumorphicPress: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98: 1)
            .animation(.easeOut(duration: 0.1))
            .shadow(color:  colorScheme == .light ? Color("shadow").opacity(0.3) : Color("darkShadow").opacity(0.95), radius: configuration.isPressed ? 1 : 5 , x: configuration.isPressed ? 1 : 5, y: configuration.isPressed ? 1 : 5)
            .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Color("blackShadow").opacity(0.4), radius: configuration.isPressed ? 1 : 5, x: configuration.isPressed ? -1 : -5, y: configuration.isPressed ? -1 : -5)
    }
}


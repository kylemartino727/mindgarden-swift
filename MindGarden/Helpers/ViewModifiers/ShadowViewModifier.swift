//
//  ShadowViewModifier.swift
//  MindGarden
//
//  Created by Mark Jones on 6/12/21.
//

import SwiftUI
struct ShadowViewModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func body(content: Content) -> some View {
        content
            .shadow(color: colorScheme == .light ? Clr.shadow.opacity(0.3) : Clr.darkShadow.opacity(0.95), radius: 5 , x: 5, y: 5)
            .shadow(color: colorScheme == .light ? Color.white.opacity(0.95) : Clr.blackShadow.opacity(0.4), radius: 5, x: -5, y: -5)
    }
}

extension View {
    /// Adds a shadow onto this view with the specified `ShadowStyle`
    func neoShadow() -> some View {
        self.modifier(ShadowViewModifier())
    }
}

//
//  Util.swift
//  MindGarden
//
//  Created by Mark Jones on 6/19/21.
//

import SwiftUI
import Foundation


struct K {
    static var userPreferences = "userPreferences"
    static func getMoodImage(mood: Mood) -> Image {
        switch mood {
        case .happy:
            return Img.happy
        case .sad:
            return Img.sad
        case .angry:
            return Img.angry
        case .okay:
            return Img.okay
        default:
            return Img.okay
        }
    }

    struct defaults {
        static var favorites = "favorited"
        static var name = "name"
        static var plants = "plants"
        static var coins = "coins"
        static var joinDate = "joinDate"
        static var selectedPlant = "selectedPlant"
        static var gardenGrid = "gardenGrid"
        static var sessions = "sessions"
        static var moods = "moods"
        static var gratitudes = "gratitudes"
        static var plantSelected = "plantSelected"
        static var meditationId = "meditationId"
        static var duration = "duration"
        static var lastStreakDate = "lastStreakDate"
        static var streak = "streak"
        static var seven = "seven"
        static var thirty = "thirty"
        static var dailyBonus = "dailyBonus"
        static var meditationReminder = "meditationReminder"
        static var loggedIn = "loggedIn"
        static var onboarding = "onboarding"
        static var referred = "referred"
    }
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }

    static func isIpod() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH <= 568.0
    }

    static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static func hasNotch() -> Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }

    static func isSmall() -> Bool {
        return UIDevice.current.type == .iPhone_6_6S_7_8_SE2 || UIDevice.current.type == .iPhone_5_5S_5C_SE1
    }
}

extension UIDevice {
    enum `Type` {
        case iPhone_5_5S_5C_SE1
        case iPhone_6_6S_7_8_SE2
        case iPhone_6_6S_7_8_PLUS
        case iPhone_X_XS_12mini
        case iPhone_XR_11
        case iPhone_XS_11Pro_Max
        case iPhone_12_Pro
        case iPhone_12_Pro_Max
    }

    var hasHomeButton: Bool {
        switch type {
        case . iPhone_X_XS_12mini, . iPhone_XR_11, .iPhone_XS_11Pro_Max, .iPhone_12_Pro, .iPhone_12_Pro_Max:
            return false
        default:
            return true
        }
    }

    var type: Type {
        if userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhone_5_5S_5C_SE1
        case 1334:
            return .iPhone_6_6S_7_8_SE2
        case 1920, 2208:
            return .iPhone_6_6S_7_8_PLUS
        case 2436:
            return .iPhone_X_XS_12mini
        case 2532:
            return .iPhone_12_Pro
        case 2688:
            return .iPhone_XS_11Pro_Max
        case 2778:
            return .iPhone_12_Pro_Max
        case 1792:
            return .iPhone_XR_11
        default:
            assertionFailure("Unknown phone device detected!")
            return .iPhone_6_6S_7_8_SE2
        }
    } else {
        assertionFailure("Unknown idiom device detected!")
        return .iPhone_6_6S_7_8_SE2
    }
   }
}

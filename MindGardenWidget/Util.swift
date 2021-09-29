//
//  Util.swift
//  MindGardenWidgetExtension
//
//  Created by Mark Jones on 12/28/21.
//

import SwiftUI

struct K {
    static func getMoodImage(mood: Mood) -> Image {
        switch mood {
        case .happy:
            return Image("happy")
        case .sad:
            return Image("sad")
        case .angry:
            return Image("angry")
        case .okay:
            return Image("okay")
        default:
            return Image("okay")
        }
    }

    static let plantImages = ["White Daisy":"daisy3", "Red Tulip":"redTulips3", "Cactus":"cactus3", "Blueberry":"blueberry3", "Monstera":"monstera3", "Daffodil":"daffodil3", "Rose":"rose3", "Lavender":"lavender3", "Sunflower":"sunflower3", "Lily of the Valley":"lilyValley3", "Lily":"lily3",  "Strawberry":"strawberry3", "Aloe":"aloe3", "Camellia":"camellia3", "Cherry Blossoms":"cherryBlossoms3", "Red Mushroom":"redMushroom3", "Bonsai Tree":"bonsai3", "Venus Fly Trap":"venus3", "Christmas Tree":"christmas3"]



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
}

    enum Mood: String {
        case happy
        case okay
        case sad
        case angry
        case none

        var title: String {
            switch self {
            case .happy: return "happy"
            case .okay: return "okay"
            case .sad: return "sad"
            case .angry: return "angry"
            case .none: return "none"
            }
        }

        static func getMood(str: String) -> Mood {
            switch str {
            case "happy":
                return .happy
            case "okay":
                return .okay
            case "sad":
                return .sad
            case "angry":
                return .angry
            case "none":
                return .none
            default:
                return .none
            }
        }

        var color: Color {
            switch self {
            case .happy: return Color("brightGreen")
            case .okay: return Color("gardenGray")
            case .sad: return Color("gardenBlue")
            case .angry: return Color("gardenRed")
            case .none: return Color("dirtBrown")
            }
        }
    }

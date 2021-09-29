//
//  Sound.swift
//  MindGarden
//
//  Created by Mark Jones on 8/8/21.
//

import SwiftUI

enum Sound {
    case rain
    case night
    case nature
    case fire
    case beach
    case noSound

    var img: Image {
        switch self {
        case .rain:
            return Image(systemName: "cloud.rain")
        case .night:
            return Image(systemName: "moon.stars")
        case .nature:
            return Image(systemName: "leaf")
        case .beach:
            return Image("beach")
        case .fire:
            return Image(systemName: "flame")
        case .noSound:
            return Image("beach")
        }
    }

    var title: String {
        switch self {
        case .rain:
            return "rain"
        case .night:
            return "night"
        case .nature:
            return "nature"
        case .beach:
            return "beach"
        case .fire:
            return "fire"
        case .noSound:
            return "noSound"
        }
    }

    static func getSound(str: String) -> Sound {
        switch str {
        case "rain":
            return .rain
        case "night":
            return .night
        case "nature":
            return .nature
        case "beach":
            return .beach
        case "fire":
            return .fire
        case "noSound":
            return .noSound
        default:
            return .noSound
        }
    }
}

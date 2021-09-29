//
//  ProfileViewModel.swift
//  MindGarden
//
//  Created by Mark Jones on 8/31/21.
//

import Swift
import Combine
import Firebase
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = true
    @Published var signUpDate: String = ""
    @Published var totalMins: Int = 0
    @Published var totalSessions: Int = 0
    @Published var name: String = ""

    init() {}

    func update(userModel: UserViewModel, gardenModel: GardenViewModel) {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        self.signUpDate = userModel.joinDate
        self.name = userModel.name
        self.totalMins = gardenModel.allTimeMinutes
        self.totalSessions = gardenModel.allTimeSessions
    }

    func signOut() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        UserDefaults.standard.setValue(false, forKey: K.defaults.loggedIn)
        UserDefaults.standard.setValue("White Daisy", forKey: K.defaults.selectedPlant)
        UserDefaults.standard.setValue(false, forKey: "isPro")
        UserDefaults.standard.setValue("", forKey: K.defaults.onboarding)
        UserDefaults.standard.setValue("nature", forKey: "sound")
        UserDefaults.standard.setValue(50, forKey: "coins")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "joinDate")
    }
}
